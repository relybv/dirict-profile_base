# == Class profile_base::install
#
# This class is called from profile_base for install.
#
class profile_base::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }


  # prefer ipv4
  class { 'gai::preferipv4': }

  # install packages
  ensure_packages($::profile_base::packages, {
    'ensure'  => 'latest',
    'require' => Class['gai::preferipv4'],
  })

  # if monitor address is defined use it as syslogserver
  if $profile_base::monitor_address != undef {
    class { 'rsyslog::client':
      log_remote           => true,
      spool_size           => '1g',
      spool_timeoutenqueue => false,
      remote_type          => 'tcp',
      server               => $profile_base::monitor_address,
      port                 => '514',
    }
  }

}
