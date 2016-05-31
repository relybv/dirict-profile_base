# == Class profile_base::windows::config
#
# This class is called from profile_base for service config.
#
class profile_base::windows::config {
  class { 'motd':
    content => 'This host is under control of puppet/nPlease do not change the configuration manual/n',
  }
}
