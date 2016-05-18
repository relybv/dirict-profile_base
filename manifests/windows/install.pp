# == Class profile_base::windows::install
#
# This class is called from profile_base for install.
#
class profile_base::windows::install {

  # install packages
  include chocolatey
  Package { provider => chocolatey, }

  # if monitor address is defined use it as syslogserver
#  if $profile_base::monitor_address != undef {
    include nxlog
    nxlog::input {'eventlogs':
      input_name   => 'eventlogs',
      input_module => 'im_msvistalog',
#      query        => '<QueryList><Query Id="0"><Select Path="Application">*</Select><Select Path="Security">*</Select><Select Path="System">*</Select></Query>y</QueryList>',
    }
    nxlog::output {'out':
      output_name   => 'out',
      output_module => 'om_tcp',
      output_host    => '172.16.20.201',
      output_port   => '514',
      output_exec   => 'to_syslog_snare();',
    }
    # must route to existing output defined above
    nxlog::route {'route1':
      route_name => 'route1',
      route_path => 'eventlogs => out',
    }
#  }

}
