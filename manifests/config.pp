# == Class profile_base::config
#
# This class is called from profile_base for service config.
#
class profile_base::config {
  class { 'motd':
    content => 'This host is under control of puppet/nPlease do not change the configuration manual/n',
  }

  # save exported facts provided at provisioning to custom facts
  exec { 'create_fact_file':
    path    => ['/usr/bin', '/bin'],
    cwd     => '/opt/puppetlabs/facter/facts.d',
    command => 'echo \'---\' > fromexport.yaml',
    creates => '/opt/puppetlabs/facter/facts.d/fromexport.yaml',
  }

  $sedstr1 = '\'s/=/:/g\''
  $swedstr2 = '\'s/"/ /g\''
  exec { 'save_facts':
    path        => ['/usr/bin', '/bin'],
    cwd         => '/opt/puppetlabs/facter/facts.d',
    provider    => shell,
    command     => "export|grep FACTER |cut -d _ -f 2,3 | sed ${sedstr1} | sed ${swedstr2} >> fromexport.yaml",
    subscribe   => Exec[ 'create_fact_file' ],
    refreshonly => true,
  }
    
}
