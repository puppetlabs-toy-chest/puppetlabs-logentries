# Class: logentries::install
#
# This class installs logentries for the given operating system
#
# Parameters:
#
# Sample Usage:
#
# class { 'logentries::install': }
#
class logentries::install(
  $package_name   = $::logentries::params::package_name,
  $package_manage = $::logentries::params::package_manage,
  $package_ensure = $::logentries::params::package_ensure,
  $repo_manage    = $::logentries::params::repo_manage,
) inherits logentries::params {
  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
  }

  if ($repo_manage) {
    case $::operatingsystem {
      'RedHat', 'CentOS', 'Fedora', 'Amazon': {
        $rpm_key = '/etc/pki/rpm-gpg/RPM-GPG-KEY-logentries'

        file { $rpm_key:
          ensure => present,
          source => 'puppet:///modules/logentries/RPM-GPG-KEY-logentries',
        }

        exec { 'import_key':
          command     => "rpm --import ${rpm_key}",
          subscribe   => File[$rpm_key],
          refreshonly => true,
        }

        yumrepo { 'logentries':
          descr    => "logentries ${::operatingsystemrelease} ${::architecture} Repository ",
          enabled  => 1,
          baseurl  => $::logentries::params::yum_baseurl,
          gpgcheck => 1,
          gpgkey   => 'http://rep.logentries.com/RPM-GPG-KEY-logentries',
        }
      }
      'Ubuntu', 'Debian': {
        apt::source { 'logentries':
          location    => 'http://rep.logentries.com/',
          repos       => 'main',
          include_src => false,
          key         => 'C43C79AD',
          key_server  => 'keyserver.ubuntu.com',
        }
      }
      default: {
        include role::generic
      }
    }
  }


  if ($package_manage) {
    $package_require = $::logentries::params::package_require
  } else {
    $package_require = []
  }

  package { $package_name:
    ensure  => $package_ensure,
    require => $package_require
  }
}
