# == Class profile_base::service
#
# This class is meant to be called from profile_base.
# It ensure the service is running.
#
class profile_base::service {

  service { $::profile_base::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
