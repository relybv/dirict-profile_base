# == Class profile_base::windows::config
#
# This class is called from profile_base for service config.
#
class profile_base::windows::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  class { 'motd':
    content => 'This host is under control of puppet, please do not change the configuration manual',
  }
}
