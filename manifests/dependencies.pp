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

class logentries::dependencies {

  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
  }

  case $::operatingsystem {
    'Fedora', 'fedora', 'RedHat', 'redhat', 'centos', 'Amazon': {

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

      yumrepo { 'logentries':
        descr    => "logentries $::operatingsystemrelease $::architecture Repository ",
        enabled  => 1,
        baseurl  => $::operatingsystem ? {
          /(Fedora|fedora|RedHat|redhat|centos)/ =>  "http://rep.logentries.com/rh/${basearch}",
          'Amazon'                               =>  "http://rep.logentries.com/amazon\${releasever}/\${basearch}",
        },
        gpgcheck => 1,
        gpgkey   => 'http://rep.logentries.com/RPM-GPG-KEY-logentries',
      }

      package { [ 'python-setproctitle', 'python-simplejson' ]:
        ensure  => latest,
        require => Yumrepo['logentries']
      }
    }

    'debian', 'ubuntu': {

      apt::source { 'logentries':
        location    => 'http://rep.logentries.com/',
        repos       => 'main',
        include_src => false,
        key         => 'C43C79AD',
        key_server  => 'pgp.mit.edu',
      }

      exec { 'apt-update':
        command     => '/usr/bin/apt-get update',
        refreshonly => true,
      }

      package { 'apt-transport-https':
        ensure => latest,
        require => [Apt::Source['logentries'], Exec['apt-update']]
      }

      package { 'python-setproctitle':
        ensure  => latest,
        require => Exec['apt-update']
      }

    }

    default: {
      fail('Platform not supported by logentries module. Patches welcomed.')
    }
  }
}
