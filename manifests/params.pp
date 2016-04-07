# == Class profile_base::params
#
# This class is meant to be called from profile_base.
# It sets variables according to platform.
#
class profile_base::params {
  $monitor_address = $::monitor_address
  case $::osfamily {
    'Debian': {
      $package_name = 'profile_base'
      $service_name = 'profile_base'
    }
    'RedHat', 'Amazon': {
      $package_name = 'profile_base'
      $service_name = 'profile_base'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
