# Class: logentries::params
#
# This class manages logentries parameters
#
# Parameters:
#
# Sample Usage:
#
class logentries::params {
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora': {
      $package_name    = ['python-setproctitle', 'python-simplejson', 'logentries']
      $package_require = Yum['logentries']

      $yum_baseurl = "http://rep.logentries.com/rh/${::architecture}"
    }
    'Amazon': {
      $package_name    = ['python27-simplejson', 'logentries']
      $package_require = Yum['logentries']

      $yum_baseurl = "http://rep.logentries.com/amazon\${releasever}/\${basearch}"
    }
    'Ubuntu', 'Debian': {
      $package_name = ['logentries']
      $package_require = Apt::Source['logentries']
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  $package_manage = true
  $package_ensure = present


  $service_name   = 'logentries'
  $service_manage = true
  $service_enable = true
  $service_ensure = running

  $repo_manage    = true
}
