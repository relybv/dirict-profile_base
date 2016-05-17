# == Class profile_base::windows::install
#
# This class is called from profile_base for install.
#
class profile_base::windows::install {

  # install packages
  include chocolatey
  Package { provider => chocolatey, }
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
