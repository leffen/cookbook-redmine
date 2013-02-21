maintainer       "Leffen"
maintainer_email "leffen@gmail.com"
license          "Apache 2.0"
description      "Install Redmine from Github"
version          "0.0.1"

recipe "redmine", "Install the Redmine application from the source"

%w{ git mysql build-essential database  application application_ruby nginx }.each do |dep|
  depends dep
end

%w{ debian ubuntu centos redhat amazon scientific fedora suse }.each do |os|
    supports os
end
