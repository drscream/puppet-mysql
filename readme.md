# Mysql Puppet module

This is puppet module is developed by 
[camptocamp](https://github.com/camptocamp/puppet-mysql/).

## Requirements

- Depends on the camptocamp [augeas
  module](https://github.com/camptocamp/puppet-augeas)
- Define a global path for exec (for example in `globals.pp`)
  `Exec { path => "/usr/bin:/bin/...." }`

## Usage

### Install and setup a MySQL Server

    include augeas
    include mysql::server

### Setup some own MySQL options

Listen on public IPv6 and IPv4 address.

    mysql::config { "bind-address":
        ensure => present,
        value  => "::",
    }

### Set some permissions for user and database

    mysql::rights{"Set rights for puppet database":
        ensure   => present,
        database => "puppet",
        user     => "puppet",
        password => "puppet"
    }
### Create a database

    mysql::database{"mydb":
        ensure   => present
    }
