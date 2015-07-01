# Type: logentries::follow
#
# This type configures logentries follow rules
#
# Parameters:
#
# Sample Usage:
#
# logentries::follow { '/var/log/syslog': }
#
define logentries::follow(
  $display_name = undef,
  $log_type     = undef,
) {
  $log_file = regsubst($name, '[;\\/:*?\"<>|&]', '_', 'G')

  exec { "le_follow_${name}":
    command => "le follow ${name} ${display_name} ${log_type}",
    unless  => "le followed ${name}",
    require => Class['logentries::install'],
    notify  => Class['logentries::service'],
    timeout => 30,
  }
}
