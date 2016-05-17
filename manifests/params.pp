# == Class profile_base::params
#
# This class is meant to be called from profile_base.
# It sets variables according to platform.
#
class profile_base::params {
  $monitor_address = $::monitor_address

  $ubuntu_packages = ['procps']
  $debian_packages = ['procps']
  $redhat_packages =  ['nano', 'vmstat', 'top']
  $windows_packages = ['notepad']

  case $::operatingsystem {
    'Debian': {
      $packages = $debian_packages
    }
    'Ubuntu': {
      $packages = $ubuntu_packages
    }
    'RedHat', 'CentOS': {
      $packages = $redhat_packages
    }
    'Windows': {
      $packages = $windows_packages
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
