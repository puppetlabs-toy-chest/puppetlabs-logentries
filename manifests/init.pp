# Class: logentries
#
# This class installs, configs and starts the logentries service
#
# Parameters:
#
# Sample Usage:
#
# class { 'logentries':
#   le_account_key => '',
#   le_name        => 'Puppet Master',
# }
#
class logentries(
  $le_account_key,
  $le_name,
  $le_type,
  $le_hostname,
  $le_region,

  $package_name   = $::logentries::params::package_name,
  $package_manage = $::logentries::params::package_manage,
  $package_ensure = $::logentries::params::package_ensure,

  $service_name   = $::logentries::params::service_name,
  $service_manage = $::logentries::params::service_manage,
  $service_enable = $::logentries::params::service_enable,
  $service_ensure = $::logentries::params::service_ensure,

  $repo_manage = $::logentries::params::repo_manage,
) inherits ::logentries::params {

  class { 'logentries::install':
    package_name   => $package_name,
    package_manage => $package_manage,
    package_ensure => $package_ensure,
    repo_manage    => $repo_manage,
  }

  class { 'logentries::config':
    le_account_key => $le_account_key,
    le_name        => $le_name,
    le_type        => $le_type,
    le_hostname    => $le_hostname,
    le_region      => $le_region
  }

  class { 'logentries::service':
    service_name   => $service_name,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    service_manage => $service_manage,
  }
}
