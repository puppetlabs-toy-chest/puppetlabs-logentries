#
# Author:: Mohamed Hadrouj
# Module Name:: logentries
# Class:: logentries::follow
#
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

define logentries::follow(
  $display_name='',
  $log_type='',
  ) {

  if ($display_name != '') {
    $name_flag = "--name '${display_name}'"
  }

  if ($log_type != '') {
    $type_flag = "--type '${log_type}'"
  }

  $log_file=regsubst($name, '[;\\/:*?\"<>|&]', '_', 'G')
  exec { "le_follow_${name}":
    command => "le follow ${name} ${name_flag} ${type_flag}",
    unless  => "le followed ${name}",
    path    => '/usr/bin/:/bin/',
    require => [Package['logentries'], Exec['le_register']],
    notify  => Service['logentries'],
  }
}
