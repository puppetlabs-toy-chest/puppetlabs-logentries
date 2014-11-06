require 'spec_helper'

describe 'logentries', :type => 'class' do

 context 'setting all params' do
    let(:params) { {
      :account_key => 'key',
      :le_name     => 'name',
      :le_hostname => 'hostname',
      :region_flag => '--region',
    } }

    let(:facts) { {:osfamily => 'Debian',
		   :operatingsystem => 'Ubuntu',
		   :lsbdistid => 'Ubuntu',
		   :lsbdistcodename => 'trusty' }
                }
    it { should contain_class 'logentries' }
    it { should contain_package('logentries').with_ensure('latest') }
    it { should contain_package('logentries-daemon').with_ensure('latest') }
    it { should contain_exec('le_register').with(
      'require' => 'Package[logentries]',
      'notify'  => 'Service[logentries]'
    ) }
    it { should contain_service('logentries').with(
      'ensure'      => 'running',
      'enable'      => true,
      'hasrestart'  => true
    ) }
  end
end
