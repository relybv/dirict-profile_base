# == Class: profile_base
#
# Full description of class profile_base here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class profile_base
(
  $monitor_address = $::profile_base::params::monitor_address,
) inherits ::profile_base::params {

  # validate parameters here
  if $monitor_address != undef {
    validate_string($monitor_address)
  }

  case $::operatingsystem {
    'Windows': {
      class { '::profile_base::windows::install': }
      -> class { '::profile_base::windows::config': }
      ~> class { '::profile_base::windows::service': }
      -> Class['::profile_base']
    }
    default: {
      class { '::profile_base::install': }
      -> class { '::profile_base::config': }
      ~> class { '::profile_base::service': }
      -> Class['::profile_base']
    }
  }

}
