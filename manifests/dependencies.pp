#
# Author:: James Turnbull <james@lovedthanlost.net>
# Module Name:: logentries
# Class:: logentries::dependencies
#
# Copyright 2013, Puppet Labs
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class logentries::dependencies (
  $manage_package_repo = $::logentries::params::manage_package_repo
) inherits ::logentries::params {

  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
  }

    case $::operatingsystem {
      /(?i:fedora|redhat|centos|amazon)/ : {

        $rpmkey = '/etc/pki/rpm-gpg/RPM-GPG-KEY-logentries'

        file { $rpmkey:
          ensure => present,
          source => 'puppet:///modules/logentries/RPM-GPG-KEY-logentries',
        }

        exec { 'import_key':
          command     => "/bin/rpm --import ${rpmkey}",
          subscribe   => File[$rpmkey],
          refreshonly => true,
        }

        case $::operatingsystem {
          'Amazon' : {
            $baseurl = "http://rep.logentries.com/amazon\${releasever}/\${basearch}"
            $req_packages = [ 'python27-simplejson' ]
          }
          default: {
            $baseurl = "http://rep.logentries.com/rh/${::architecture}"
            $req_packages = [ 'python-setproctitle', 'python-simplejson' ]
          }
        }

        if ($manage_package_repo == true) {
          yumrepo { 'logentries':
            descr    => "logentries ${::operatingsystemrelease} ${::architecture} Repository",
            enabled  => 1,
            baseurl  => $baseurl,
            gpgcheck => 1,
            gpgkey   => 'http://rep.logentries.com/RPM-GPG-KEY-logentries',
          }

          package { $req_packages :
            ensure  => latest,
            require => Yumrepo['logentries']
          }
        } else {
          package { $req_packages :
            ensure  => latest
          }
        }
      }

      'debian', 'Debian', 'ubuntu', 'Ubuntu' : {
        if ($manage_package_repo == true) {
          apt::source { 'logentries':
            location    => 'http://rep.logentries.com/',
            repos       => 'main',
            include_src => false,
            key         => 'C43C79AD',
            key_server  => 'keyserver.ubuntu.com',
          }
        }
      }

      default: {
        fail('Platform not supported by logentries module. Patches welcomed.')
      }
    }
}
