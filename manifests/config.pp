# Class: logentries::config
#
# This class configures logentries for the given host
#
# Parameters:
#
# Sample Usage:
#
# class { 'logentries::config':
#   le_account_key => '',
#   le_name        => 'Puppet Master',
# }
#
class logentries::config(
  $le_account_key,
  $le_name,
  $le_type,
  $le_region,
  $le_hostname = $::hostname,
) {
  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
  }

  exec { 'logentries_register':
    command => "le register --yes --account-key=${le_account_key} --name='${le_name}' --type='${le_type}' --hostname='${le_hostname}' ${le_region}",
    creates => '/etc/le/config',
    require => Class['logentries::install'],
    notify  => Class['logentries::service'],
  }
}
