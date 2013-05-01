require 'spec_helper'

describe 'logentries', :type => 'class' do

 context 'setting all params' do
    let(:params) { {
      :account_key => 'key'
    } }

    let(:facts) { {:operatingsystem => 'Debian' } }
    it { should contain_class 'logentries' }
    it { should contain_package('logentries').with_ensure('latest') }
    it { should contain_package('logentries-daemon').with_ensure('latest') }
    it { should contain_exec('le_register').with(
      'require' => 'Package[logentries]',
      'notify'  => 'Service[logentries]',
    ) }
    it { should contain_service('logentries').with(
      'ensure'      => 'running',
      'enable'      => true,
      'hasrestart'  => true
    ) }
  end
end
