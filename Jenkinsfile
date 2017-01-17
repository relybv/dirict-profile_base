node {
   stage('Checkout') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/relybv/dirict-profile_base.git'
   }
   stage('Dependencies') {
      sh 'cd $WORKSPACE'
      sh '/usr/bin/bundle install --path vendor/bundle'
      sh '/opt/puppetlabs/puppet/bin/rake spec_prep'
   }
   stage('Syntax') {
      sh '/usr/bin/bundle exec rake syntax'
   }
   stage('Lint') {
      sh '/usr/bin/bundle exec rake lint'
   }
   stage('Spec') {
      sh '/opt/puppetlabs/puppet/bin/rake spec_clean'
      sh '/usr/bin/bundle exec rake spec'
   }
   stage('Documentation') {
      sh '/opt/puppetlabs/bin/puppet resource package yard provider=puppet_gem'
      sh '/opt/puppetlabs/bin/puppet module install puppetlabs-strings'
      sh '/opt/puppetlabs/puppet/bin/puppet strings'
      publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: false, reportDir: 'doc', reportFiles: 'index.html', reportName: 'HTML Report'])
   }
   stage('Acceptance Ubuntu') 
   {
      sh 'BEAKER_set="openstack-ubuntu-server-1404-x64" /usr/bin/bundle exec rake beaker_fixtures'
   }
   stage('Acceptance Debian') {
      sh 'BEAKER_set="openstack-debian-78-x64" /usr/bin/bundle exec rake beaker_fixtures'
   }
}
