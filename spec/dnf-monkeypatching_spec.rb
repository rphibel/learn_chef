require 'chefspec'

describe 'dnf-monkeypatching' do
  platform 'centos', '8'
  step_into :dnf_package
  #chefspec_options[:log_level] = :debug
  Dnf = Chef::Provider::Package::Dnf

  context 'with package in denylist' do
    recipe do
      dnf_package 'vim'
    end

    it {
      is_expected.to install_dnf_package('vim')
    }

    before do
      current_version = Dnf::Version.new('vim', nil, nil)
      target_version = Dnf::Version.new('vim', '0:0.0', 'all')
      allow_any_instance_of(Dnf::PythonHelper).to receive(:package_query) .with(:whatavailable, any_args){ target_version }
      allow_any_instance_of(Dnf::PythonHelper).to receive(:package_query) .with(:whatinstalled, any_args){ current_version }
      allow_any_instance_of(Dnf::PythonHelper).to receive(:restart)

      expect_any_instance_of(Dnf).to receive(:dnf).with(nil, '-y', '--disableplugin=dnf-plugin-cow', 'install', ['vim-0:0.0.all']) { true }
    end
  end

  context 'with package in not denylist' do
    recipe do
      dnf_package 'not-vim'
    end

    it {
      is_expected.to install_dnf_package('not-vim')
    }

    before do
      current_version = Dnf::Version.new('not-vim', nil, nil)
      target_version = Dnf::Version.new('not-vim', '0:0.0', 'all')
      allow_any_instance_of(Dnf::PythonHelper).to receive(:package_query) .with(:whatavailable, any_args){ target_version }
      allow_any_instance_of(Dnf::PythonHelper).to receive(:package_query) .with(:whatinstalled, any_args){ current_version }
      allow_any_instance_of(Dnf::PythonHelper).to receive(:restart)

      expect_any_instance_of(Dnf).to receive(:dnf).with(nil, '-y', 'install', ['not-vim-0:0.0.all']) { true }
    end
  end
end
