# Class: logentries::service
#
# This class manages logentries service
#
# Parameters:
#
# Requires:
#   - Class[logentries::install]
#
# Sample Usage:
#
# class { 'logentries::service': }
#
class logentries::service(
  $service_name   = $::logentries::params::service_name,
  $service_ensure = $::logentries::params::service_ensure,
  $service_enable = $::logentries::params::service_enable,
  $service_manage = $::logentries::params::service_manage,
) inherits logentries::params {
  if ($service_manage) {
    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasrestart => true,
      require    => Class['logentries::install'],
    }
  }
}
