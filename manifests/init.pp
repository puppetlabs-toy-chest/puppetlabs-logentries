#
# Author:: James Turnbull <james@puppetlabs.com>
# Module Name:: logentries
#
# Copyright 2013, Puppet Labs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class logentries(
  $account_key,
  $le_name='',
  $le_hostname='',
  $region_flag='',
) {

  require logentries::dependencies

  if ($le_name != '') {
    $name_flag = "--name='${le_name}'"
  } else {
    $name_flag = undef
  }

  if ($le_hostname != '') {
    $hostname_flag = "--hostname='${le_hostname}'"
  } else {
    $hostname_flag = undef
  }

  package { [ 'logentries', 'logentries-daemon' ]:
    ensure => latest,
  }

  exec { 'le_register':
    command => "le register --yes --account-key=${account_key} ${name_flag} ${hostname_flag} ${region_flag}",
    path    => '/usr/bin/:/bin/',
    creates => '/etc/le/config',
    require => Package['logentries'],
    notify  => Service['logentries'],
  }

  service { 'logentries':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['logentries-daemon'],
  }
}
