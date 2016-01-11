# == Class profile_base::install
#
# This class is called from profile_base for install.
#
class profile_base::install {

  package { $::profile_base::package_name:
    ensure => present,
  }
}
