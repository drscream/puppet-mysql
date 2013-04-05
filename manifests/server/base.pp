/*

==Class: mysql::server::base

Parameters:
 $mysql_data_dir:
   set the data directory path, which is used to store all the databases

   If set, copies the content of the default mysql data location. This is
   necessary on Debian systems because the package installation script
   creates a special user used by the init scripts.

*/
class mysql::server::base inherits mysql::params {

  user { "mysql":
    ensure => present,
    require => Package["mysql-server"],
  }

  if !defined(Package['mysql-server']) {
    package { "mysql-server":
      ensure => installed,
    }
  }

  file { "${mysql::params::data_dir}":
    ensure  => directory,
    owner   => "mysql",
    group   => "mysql",
    seltype => "mysqld_db_t",
    require => Package["mysql-server"],
  }

  file { "/etc/mysql/my.cnf":
    ensure => present,
    path => $mysql::params::mycnf,
    owner => root,
    group => root,
    mode => 644,
    seltype => "mysqld_etc_t",
    require => Package["mysql-server"],
  }

  $logfile_group = $mysql::params::logfile_group

  file { "/etc/logrotate.d/mysql-server":
    ensure => present,
    content => $operatingsystem ? {
      /RedHat|Fedora|CentOS/ => template('mysql/logrotate.redhat.erb'),
                    /Debian/ => template('mysql/logrotate.debian.erb'),
      default => undef,
    }
  }

  file { "mysql-slow-queries.log":
    ensure  => present,
    owner   => mysql,
    group   => mysql,
    mode    => 640,
    seltype => mysqld_log_t,
    path    => $operatingsystem ? {
      /RedHat|Fedora|CentOS/ => "/var/log/mysql-slow-queries.log",
      default => "/var/log/mysql/mysql-slow-queries.log",
    };
  }

}
