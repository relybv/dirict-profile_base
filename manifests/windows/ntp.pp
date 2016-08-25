# == Class profile_base::windows::ntp
#
# This class is called from profile_base::windows:install for time sync config.
#

class profile_base::windows::ntp(
    $timeserver = $profile_base::params::wintimeserver,
    $timezone   = $profile_base::params::wintimezone,
) inherits profile_base::params {

#    $timeserver = 'bonehed.lcs.mit.edu'
#    $timezone   = 'Eastern Standard Time'

  exec {'set_time_zone':
    command => "C:\\windows\\system32\\tzutil.exe /s \"${::timezone}\"",
    before  => Service['w32time'],
  }

  service { 'w32time':
    ensure => 'running',
    enable => true,
    before => Exec['set_time_peer'],
  }

  exec { 'set_time_peer':
    command   => "C:\\windows\\system32\\w32tm.exe /config /manualpeerlist:${::wintimeserver} /syncfromflags:MANUAL",
    before    => Exec['w32tm_update_time'],
    logoutput => true,
    timeout   => '60',
  }

  exec {'w32tm_update_time':
    command   => 'C:\\windows\\system32\\w32tm.exe /config /update',
    before    => Exec['w32tm_resync'],
    logoutput => true,
    timeout   => '60',
  }

  exec {'w32tm_resync':
    command   => 'C:\\windows\\system32\\w32tm.exe /resync /nowait',
    logoutput => true,
    timeout   => '60',
    require   => Exec['w32tm_update_time'],
  }
}
