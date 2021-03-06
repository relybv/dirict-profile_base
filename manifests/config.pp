# == Class profile_base::config
#
# This class is called from profile_base for service config.
#
class profile_base::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  class { 'motd':
    content => 'This host is under control of puppet, please do not change the configuration manual',
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
    provider    => posix,
    command     => "/bin/bash -c export|grep FACTER |cut -d _ -f 2,3,4,5 | sed ${sedstr1} | sed ${swedstr2} >> fromexport.yaml",
    subscribe   => Exec[ 'create_fact_file' ],
    refreshonly => true,
  }

}
