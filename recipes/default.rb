#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2012, UMass Transit Service <transit-mis@admin.umass.edu>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Sources
# https://github.com/juanje/cookbook-redmine
# https://github.com/umts/cookbook-redmine
#
# Modified and adapted by Leif Terje Fonnes ( leffen@gmail.com), 2013


include_recipe "mysql::server"
include_recipe "build-essential"
include_recipe "git"

mysql_packages = case node['platform']
                   when "centos", "redhat", "suse", "fedora", "scientific", "amazon"
                     %w{mysql mysql-devel}
                   when "ubuntu","debian"
                     if debian_before_squeeze? || ubuntu_before_lucid?
                       %w{mysql-client libmysqlclient15-dev}
                     else
                       %w{mysql-client libmysqlclient-dev}
                     end
                 end

mysql_packages.each do |pkg|
  package pkg do
    action :nothing
  end.run_action(:install)
end

chef_gem "mysql"

db = node['redmine']['databases']
rmversion = node['redmine']['revision'].to_i

mysql_connection = { :host => "localhost", :username => 'root', :password => node['mysql']['server_root_password'] }

mysql_database db['database'] do
  connection mysql_connection
  action :create
end

mysql_database_user db['username'] do
  password db['password']
  database_name db['database']
  connection mysql_connection
  action :grant
end

application "redmine" do
  path node['redmine']['path']
  owner node['redmine']['user']
  group node['redmine']['group']

  repository node['redmine']['repo']
  revision   node['redmine']['revision']

  packages node['redmine']['packages'].values.flatten

  migrate true
  rollback_on_error false

  rails do
    gems %w{ bundler }
    bundler_without_groups %w{ postgresql sqlite3 }
    bundler_deployment false
    database do
      adapter  db['adapter']
      host     "localhost"
      database db['database']
      username db['username']
      password db['password']
    end
  end

end

execute "default_data" do
  command "bundle exec rake redmine:load_default_data"
  environment ({'RAILS_ENV' => 'production', 'REDMINE_LANG' => 'en'})
  cwd "#{node['redmine']['path']}/current"
  action :run
end

execute 'bundle exec rake generate_session_store' do
  cwd "#{node['redmine']['path']}/current"
  not_if { ::File.exists?("#{node['redmine']['path']}/current/config/initializers/secret_token.rb") }
end


template "/etc/init.d/unicorn_redmine" do
  source "unicorn_init_script.erb"
  owner  "root"
  group  "root"
  mode   "0700"
end

# Redmine configuration for SCM and mailing
template "#{node['redmine']['path']}/shared/config/configuration.yml" do
  source "configuration.yml.erb"
  owner "www-data"
  group "www-data"
  mode  "0644"
end

# Redmine unicorn configuration
template "#{node['redmine']['path']}/shared/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner "www-data"
  group "www-data"
  mode  "0644"
end

template "/etc/nginx/sites-enabled/redmine.conf" do
  source "redmine.conf.erb"


  notifies :reload, resources(:service => "nginx")
end




