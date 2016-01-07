require 'spec_helper'

describe package 'tor' do
  it { should be_installed }
end

describe process 'tor' do
  it { should be_running }
  its(:user) { should eq 'debian-tor' }
end

describe port 9050 do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe file '/var/lib/tor/hidden_service/private_key' do
  it { should be_file }
end

describe file '/var/lib/tor/hidden_service/hostname' do
  it { should be_file }
end
