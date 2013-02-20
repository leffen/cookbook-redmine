Description
===========

Install redmine with mysql, nginx and unicorn.

This cookbook expects Ruby to be already installed on the server.


Requirements
============

## Platform:

Tested on:

* Ubuntu 12.04

## Cookbooks:

* apt
* yum
* runit
* git
* mysql
* build-essential
* openssl


Attributes
==========

This cookbook uses many attributes, broken up into a few different kinds.

Usage
=====

This cookbook installs Redmine with a defaults confirations to have it working
out the box. But if you like to customize them, just chage it at the attributes.

The easy way is to create your own role and specify your preferences. Here is
an example:

    # roles/redmine.rb
    name "redmine"
    description "Redmine box to manage all the tickets"
    run_list("recipe[redmine]")
    default_attributes(
      "redmine" => {
        "path" => "/opt/redmine",
        "user" => "deploy_user",
        "group" => "deploy_group",
        "rmagick" => "true",
        "databases" => {
          "production" => {
            "password" => "redmine_password"
          }
        }
      },
      "mysql" => {
        "server_root_password" => "SomeLongAndDifficultPassword",
        "server_debian_password" => "SomeLongAndDifficultPasswordDebx",
        "server_repl_password" => "SomeLongAndDifficultPasswordRepl",

        "server_root_password" => "supersecret_password"
      }
    )



This cookbook is a fork from : https://github.com/juanje/cookbook-redmine
Some of the content is also from https://github.com/umts/cookbook-redmine
and https://github.com/lebedevdsl/redmine

Original License and Author
==================

Author:: Juanje Ojeda (<juanje.ojeda@gmail.com>)

Copyright:: 2012, Juanje Ojeda (<juanje.ojeda@gmail.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
