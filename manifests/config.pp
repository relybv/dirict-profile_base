# == Class profile_base::config
#
# This class is called from profile_base for service config.
#
class profile_base::config {
  class { 'motd':
    content => 'This host is under control of puppet/nPlease do not change the configuration manual/n',
  }
}
