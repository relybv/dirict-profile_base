node {
   properties([parameters([string(defaultValue: 'https://access.openstack.rely.nl:5000/v2.0', description: '', name: 'OS_AUTH_URL'), string(defaultValue: 'lab', description: '', name: 'OS_TENANT_NAME'), string(defaultValue: '10593dbf4f8d4296a25cf942f0567050', description: '', name: 'OS_TENANT_ID'), string(defaultValue: 'paul.gomersbach', description: '', name: 'OS_USERNAME'), string(defaultValue: 'RegionOne', description: '', name: 'OS_REGION_NAME'), [$class: 'CredentialsParameterDefinition', credentialType: 'org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl', defaultValue: 'OS_PASSWORD', description: '', name: 'OS_PASSWORD', required: false]]), disableConcurrentBuilds(), pipelineTriggers([[$class: 'GitHubPushTrigger'], pollSCM('H/15 * * * *')])])
   stage('Checkout') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/relybv/dirict-profile_base.git'
   }
   stage('Dependencies') {
      sh 'cd $WORKSPACE'
      sh '/usr/bin/bundle install --path vendor/bundle'
      sh '/opt/puppetlabs/puppet/bin/rake spec_prep'
      sh 'printenv'
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
   stage('Acceptance Ubuntu') {
      sh 'BEAKER_set="openstack-ubuntu-server-1404-x64" /usr/bin/bundle exec rake beaker_fixtures'
   }
   stage('Acceptance Debian') {
      sh 'BEAKER_set="openstack-debian-78-x64" /usr/bin/bundle exec rake beaker_fixtures'
   }
}
