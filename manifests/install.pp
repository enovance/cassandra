# == Class: cassandra::install
#
# Please see the README for this module for full details of what this class
# does as part of the module and how to use it.
#
class cassandra::install (
  $cassandra_opt_package_name   = undef,
  $cassandra_opt_package_ensure = 'present',
  $cassandra_package_ensure     = 'present',
  $cassandra_package_name       = 'dsc21',
  $java_package_ensure          = 'present',
  $java_package_name            = undef,
  $manage_dsc_repo              = false,
  ) {

  case $::osfamily {
    'RedHat': {
      if $manage_dsc_repo == true {
        yumrepo { 'datastax':
          ensure   => present,
          descr    => 'DataStax Repo for Apache Cassandra',
          baseurl  => 'http://rpm.datastax.com/community',
          enabled  => 1,
          gpgcheck => 0,
          before   => Package[ $cassandra_package_name ],
        }
      }
    }
    default: {
      fail("OS family ${::osfamily} not supported")
    }
  }

  if $java_package_name != undef {
    package { $java_package_name:
      ensure => $java_package_ensure,
      before => Package[ $cassandra_package_name ],
    }
  }

  package { $cassandra_package_name:
    ensure => $cassandra_package_ensure,
  }

  if $cassandra_opt_package_name != undef {
    package { $cassandra_opt_package_name:
      ensure  => $cassandra_opt_package_ensure,
      require => Package[$cassandra_package_name],
    }
  }
}
