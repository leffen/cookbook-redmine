# generic attribs
default["redmine"]["repo"]      = 'git://github.com/redmine/redmine.git'
default["redmine"]["revision"]  = '2.2.3'
default["redmine"]["path"]      = '/var/www/redmine'
default["redmine"]["user"]      = 'redmine'
default["redmine"]["group"]     = 'redmine'


# databases
default["redmine"]["databases"]["adapter"]  = 'mysql2'
default["redmine"]["databases"]["database"] = 'redmine'
default["redmine"]["databases"]["username"] = 'redmine'
default["redmine"]["databases"]["password"] = 'UltruxPlokk2345!'

default["redmine"]["server_aliases"] = []

default["redmine"]["nginx"]["port"] = "85"
default["redmine"]["nginx"]["app_server_name"] = "redmine.sample.com"
default["redmine"]["unicorn_conf"]["pid"] = "/tmp/pids/unicorn.pid"
default["redmine"]["unicorn_conf"]["sock"] = "/tmp/sockets/unicorn.sock"
default["redmine"]["unicorn_conf"]["error_log"] = "unicorn_redmine.error.log"
default["redmine"]["unicorn_conf"]["access_log"] = "unicorn_redmine.access.log"

# packages
# packages are separated to better tracking
case platform
  when "redhat","centos","amazon","scientific","fedora","suse"
    default["redmine"]["packages"] = {
        "rmagick" => %w{ ImageMagick ImageMagick-devel },
        #TODO: SCM packages should be installed only if they are goin to be used
        #NOTE: git will be installed with a recipe because is needed for the deploy resource
        "scm"     => %w{ subversion bzr mercurial darcs cvs }
    }
  when "debian","ubuntu"
    default["redmine"]["packages"] = {
        "rmagick" => %w{ libmagickcore-dev libmagickwand-dev librmagick-ruby },
        #TODO: SCM packages should be installed only if they are goin to be used
        #NOTE: git will be installed with a recipe because is needed for the deploy resource
        "scm"     => %w{ subversion bzr mercurial darcs cvs }
    }
end
