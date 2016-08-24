if ENV['BEAKER'] == 'true'
  # running in BEAKER test environment
  require 'spec_helper_acceptance'
else
  # running in non BEAKER environment
  require 'serverspec'
  set :backend, :exec
end

describe 'profile_base class' do

  context 'default parameters' do
    if ENV['BEAKER'] == 'true'
      # Using puppet_apply as a helper
      it 'should work idempotently with no errors' do
        pp = <<-EOS
        class { 'profile_base': }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, :catch_failures => true, :future_parser => true)
        apply_manifest(pp, :catch_changes  => true, :future_parser => true)
      end
    end

    describe host('8.8.8.8') do
      it { should be_reachable }
      it { should be_reachable.with( :port => 53, :proto => 'udp' ) }
    end

    describe package('procps') do
      it { is_expected.to be_installed }
    end

    describe package('ntp') do
      it { is_expected.to be_installed }
    end

    describe service('ntp') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file('/etc/motd') do
      its(:content) { should match /This host is under control of puppet/ }
    end

    describe file('/opt/puppetlabs/facter/facts.d/fromexport.yaml') do
      its(:content) { should match /---/ }
    end

  end
end
