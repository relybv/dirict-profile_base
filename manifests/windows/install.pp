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
    include nxlog
    nxlog::input {'eventlogs':
      input_name   => 'eventlogs',
      input_module => 'im_msvistalog',
    }
    nxlog::output {'out':
      output_name   => 'out',
      output_module => 'om_tcp',
      output_host   => $profile_base::monitor_address,
      output_port   => '514',
      output_exec   => 'to_syslog_snare();',
    }
    # must route to existing output defined above
    nxlog::route {'route1':
      route_name => 'route1',
      route_path => 'eventlogs => out',
    }
  }

}
