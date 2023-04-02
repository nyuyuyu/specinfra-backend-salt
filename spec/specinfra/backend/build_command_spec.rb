# coding: utf-8
# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength, Layout/LineLength
RSpec.describe Specinfra::Backend::Salt do
  before(:all) do
    set :backend, :salt
    set :host, 'localhost'
  end

  describe '#build_command' do
    subject { Specinfra.backend.build_command(cmd) }

    shared_examples 'builded simple command' do |ret|
      let(:cmd) { 'test -f /etc/passwd' }
      it { expect(subject).to eq ret }
    end

    shared_examples 'builded complex command' do |ret|
      let(:cmd) do
        'test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)'
      end
      it { expect(subject).to eq ret }
    end

    context 'without any options' do
      it_should_behave_like 'builded simple command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\ -f\\\\\ /etc/passwd\\\\\;)
      it_should_behave_like 'builded complex command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\\ \\\\\\!\\\\\\ -f\\\\\\ /etc/selinux/config\\\\\\ \\\\\\|\\\\\\|\\\\\\ \\\\\\(getenforce\\\\\\ \\\\\\|\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ disabled\\\\\\ \\\\\\&\\\\\\&\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ \\\\\\^SELINUX\\\\\\=disabled\\\\\\$\\\\\\ /etc/selinux/config\\\\\\)\\\\\\;)
    end

    context 'with pre_command' do
      before do
        RSpec.configure do |c|
          c.pre_command = 'source /etc/profile'
        end
      end

      it_should_behave_like 'builded simple command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ source\\\\\ /etc/profile\\\\\ \\\\\&\\\\\&\\\\\ test\\\\\ -f\\\\\ /etc/passwd\\\\\;)
      it_should_behave_like 'builded complex command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ source\\\\\ /etc/profile\\\\\ \\\\\&\\\\\&\\\\\ test\\\\\\ \\\\\\!\\\\\\ -f\\\\\\ /etc/selinux/config\\\\\\ \\\\\\|\\\\\\|\\\\\\ \\\\\\(getenforce\\\\\\ \\\\\\|\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ disabled\\\\\\ \\\\\\&\\\\\\&\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ \\\\\\^SELINUX\\\\\\=disabled\\\\\\$\\\\\\ /etc/selinux/config\\\\\\)\\\\\\;)

      after do
        RSpec.configure do |c|
          c.pre_command = nil
        end
      end
    end

    context 'with env' do
      before do
        RSpec.configure do |c|
          c.env = { LANG: 'ja_JP.UTF-8', FOO: 'bar' }
        end
      end

      it_should_behave_like 'builded simple command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"ja_JP.UTF-8\",\"FOO\":\"bar\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\ -f\\\\\ /etc/passwd\\\\\;)
      it_should_behave_like 'builded complex command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"ja_JP.UTF-8\",\"FOO\":\"bar\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\\ \\\\\\!\\\\\\ -f\\\\\\ /etc/selinux/config\\\\\\ \\\\\\|\\\\\\|\\\\\\ \\\\\\(getenforce\\\\\\ \\\\\\|\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ disabled\\\\\\ \\\\\\&\\\\\\&\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ \\\\\\^SELINUX\\\\\\=disabled\\\\\\$\\\\\\ /etc/selinux/config\\\\\\)\\\\\\;)

      after do
        RSpec.configure do |c|
          c.env = {}
        end
      end
    end

    context 'with shell' do
      before do
        RSpec.configure do |c|
          c.shell = '/bin/bash'
        end
      end

      it_should_behave_like 'builded simple command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/bash\'\ test\\\\\ -f\\\\\ /etc/passwd\\\\\;)
      it_should_behave_like 'builded complex command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/bash\'\ test\\\\\\ \\\\\\!\\\\\\ -f\\\\\\ /etc/selinux/config\\\\\\ \\\\\\|\\\\\\|\\\\\\ \\\\\\(getenforce\\\\\\ \\\\\\|\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ disabled\\\\\\ \\\\\\&\\\\\\&\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ \\\\\\^SELINUX\\\\\\=disabled\\\\\\$\\\\\\ /etc/selinux/config\\\\\\)\\\\\\;)

      after do
        RSpec.configure do |c|
          c.shell = nil
        end
      end
    end

    context 'with user' do
      before do
        set :salt_user, 'vagrant'
      end

      it_should_behave_like 'builded simple command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ runas\=\'vagrant\'\ shell\=\'/bin/sh\'\ test\\\\\ -f\\\\\ /etc/passwd\\\\\;)
      it_should_behave_like 'builded complex command', \
                            %q(sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ runas\=\'vagrant\'\ shell\=\'/bin/sh\'\ test\\\\\\ \\\\\\!\\\\\\ -f\\\\\\ /etc/selinux/config\\\\\\ \\\\\\|\\\\\\|\\\\\\ \\\\\\(getenforce\\\\\\ \\\\\\|\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ disabled\\\\\\ \\\\\\&\\\\\\&\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ \\\\\\^SELINUX\\\\\\=disabled\\\\\\$\\\\\\ /etc/selinux/config\\\\\\)\\\\\\;)
    end

    context 'with sudo user' do
      before do
        set :salt_sudo_user, 'vagrant'
      end

      it_should_behave_like 'builded simple command', \
                            %q(sudo -S -u vagrant /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\ -f\\\\\ /etc/passwd\\\\\;)
      it_should_behave_like 'builded complex command', \
                            %q(sudo -S -u vagrant /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\\ \\\\\\!\\\\\\ -f\\\\\\ /etc/selinux/config\\\\\\ \\\\\\|\\\\\\|\\\\\\ \\\\\\(getenforce\\\\\\ \\\\\\|\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ disabled\\\\\\ \\\\\\&\\\\\\&\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ \\\\\\^SELINUX\\\\\\=disabled\\\\\\$\\\\\\ /etc/selinux/config\\\\\\)\\\\\\;)
    end

    context 'with sudo path' do
      before do
        set :salt_sudo_path, '/usr/bin'
      end

      it_should_behave_like 'builded simple command', \
                            %q(/usr/bin/sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\ -f\\\\\ /etc/passwd\\\\\;)
      it_should_behave_like 'builded complex command', \
                            %q(/usr/bin/sudo -S -u root /bin/sh -c salt\ -L\ localhost\ --out\=json\ cmd.run\ env\=\'\{\"LANG\":\"C\"\}\'\ shell\=\'/bin/sh\'\ test\\\\\\ \\\\\\!\\\\\\ -f\\\\\\ /etc/selinux/config\\\\\\ \\\\\\|\\\\\\|\\\\\\ \\\\\\(getenforce\\\\\\ \\\\\\|\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ disabled\\\\\\ \\\\\\&\\\\\\&\\\\\\ grep\\\\\\ -i\\\\\\ --\\\\\\ \\\\\\^SELINUX\\\\\\=disabled\\\\\\$\\\\\\ /etc/selinux/config\\\\\\)\\\\\\;)
    end

    context 'with su' do
      before do
        set :salt_become_method, :su
      end

      it_should_behave_like 'builded simple command', \
                            %q(su root -c /bin/sh\\ -c\\ salt\\\\\\ -L\\\\\\ localhost\\\\\\ --out\\\\\\=json\\\\\\ cmd.run\\\\\\ env\\\\\\=\\\\\\'\\\\\\{\\\\\\"LANG\\\\\\":\\\\\\"C\\\\\\"\\\\\\}\\\\\\'\\\\\\ shell\\\\\\=\\\\\\'/bin/sh\\\\\\'\\\\\\ test\\\\\\\\\\\\\\ -f\\\\\\\\\\\\\\ /etc/passwd\\\\\\\\\\\\\\;\\ 2\\>\\ /dev/null)
      it_should_behave_like 'builded complex command', \
                            %q(su root -c /bin/sh\\ -c\\ salt\\\\\\ -L\\\\\\ localhost\\\\\\ --out\\\\\\=json\\\\\\ cmd.run\\\\\\ env\\\\\\=\\\\\\'\\\\\\{\\\\\\"LANG\\\\\\":\\\\\\"C\\\\\\"\\\\\\}\\\\\\'\\\\\\ shell\\\\\\=\\\\\\'/bin/sh\\\\\\'\\\\\\ test\\\\\\\\\\\\\\ \\\\\\\\\\\\\\!\\\\\\\\\\\\\\ -f\\\\\\\\\\\\\\ /etc/selinux/config\\\\\\\\\\\\\\ \\\\\\\\\\\\\\|\\\\\\\\\\\\\\|\\\\\\\\\\\\\\ \\\\\\\\\\\\\\(getenforce\\\\\\\\\\\\\\ \\\\\\\\\\\\\\|\\\\\\\\\\\\\\ grep\\\\\\\\\\\\\\ -i\\\\\\\\\\\\\\ --\\\\\\\\\\\\\\ disabled\\\\\\\\\\\\\\ \\\\\\\\\\\\\\&\\\\\\\\\\\\\\&\\\\\\\\\\\\\\ grep\\\\\\\\\\\\\\ -i\\\\\\\\\\\\\\ --\\\\\\\\\\\\\\ \\\\\\\\\\\\\\^SELINUX\\\\\\\\\\\\\\=disabled\\\\\\\\\\\\\\$\\\\\\\\\\\\\\ /etc/selinux/config\\\\\\\\\\\\\\)\\\\\\\\\\\\\\;\\ 2\\>\\ /dev/null)
    end

    context 'with su user' do
      before do
        set :salt_become_method, :su
        set :salt_su_user, 'vagrant'
      end

      it_should_behave_like 'builded simple command', \
                            %q(su vagrant -c /bin/sh\\ -c\\ salt\\\\\\ -L\\\\\\ localhost\\\\\\ --out\\\\\\=json\\\\\\ cmd.run\\\\\\ env\\\\\\=\\\\\\'\\\\\\{\\\\\\"LANG\\\\\\":\\\\\\"C\\\\\\"\\\\\\}\\\\\\'\\\\\\ shell\\\\\\=\\\\\\'/bin/sh\\\\\\'\\\\\\ test\\\\\\\\\\\\\\ -f\\\\\\\\\\\\\\ /etc/passwd\\\\\\\\\\\\\\;\ 2\\>\\ /dev/null)
      it_should_behave_like 'builded complex command', \
                            %q(su vagrant -c /bin/sh\\ -c\\ salt\\\\\\ -L\\\\\\ localhost\\\\\\ --out\\\\\\=json\\\\\\ cmd.run\\\\\\ env\\\\\\=\\\\\\'\\\\\\{\\\\\\"LANG\\\\\\":\\\\\\"C\\\\\\"\\\\\\}\\\\\\'\\\\\\ shell\\\\\\=\\\\\\'/bin/sh\\\\\\'\\\\\\ test\\\\\\\\\\\\\\ \\\\\\\\\\\\\\!\\\\\\\\\\\\\\ -f\\\\\\\\\\\\\\ /etc/selinux/config\\\\\\\\\\\\\\ \\\\\\\\\\\\\\|\\\\\\\\\\\\\\|\\\\\\\\\\\\\\ \\\\\\\\\\\\\\(getenforce\\\\\\\\\\\\\\ \\\\\\\\\\\\\\|\\\\\\\\\\\\\\ grep\\\\\\\\\\\\\\ -i\\\\\\\\\\\\\\ --\\\\\\\\\\\\\\ disabled\\\\\\\\\\\\\\ \\\\\\\\\\\\\\&\\\\\\\\\\\\\\&\\\\\\\\\\\\\\ grep\\\\\\\\\\\\\\ -i\\\\\\\\\\\\\\ --\\\\\\\\\\\\\\ \\\\\\\\\\\\\\^SELINUX\\\\\\\\\\\\\\=disabled\\\\\\\\\\\\\\$\\\\\\\\\\\\\\ /etc/selinux/config\\\\\\\\\\\\\\)\\\\\\\\\\\\\\;\ 2\\>\\ /dev/null)
    end

    context 'with su path' do
      before do
        set :salt_become_method, :su
        set :salt_su_path, '/usr/bin'
      end

      it_should_behave_like 'builded simple command', \
                            %q(/usr/bin/su root -c /bin/sh\\ -c\\ salt\\\\\\ -L\\\\\\ localhost\\\\\\ --out\\\\\\=json\\\\\\ cmd.run\\\\\\ env\\\\\\=\\\\\\'\\\\\\{\\\\\\"LANG\\\\\\":\\\\\\"C\\\\\\"\\\\\\}\\\\\\'\\\\\\ shell\\\\\\=\\\\\\'/bin/sh\\\\\\'\\\\\\ test\\\\\\\\\\\\\\ -f\\\\\\\\\\\\\\ /etc/passwd\\\\\\\\\\\\\\;\ 2\\>\\ /dev/null)
      it_should_behave_like 'builded complex command', \
                            %q(/usr/bin/su root -c /bin/sh\\ -c\\ salt\\\\\\ -L\\\\\\ localhost\\\\\\ --out\\\\\\=json\\\\\\ cmd.run\\\\\\ env\\\\\\=\\\\\\'\\\\\\{\\\\\\"LANG\\\\\\":\\\\\\"C\\\\\\"\\\\\\}\\\\\\'\\\\\\ shell\\\\\\=\\\\\\'/bin/sh\\\\\\'\\\\\\ test\\\\\\\\\\\\\\ \\\\\\\\\\\\\\!\\\\\\\\\\\\\\ -f\\\\\\\\\\\\\\ /etc/selinux/config\\\\\\\\\\\\\\ \\\\\\\\\\\\\\|\\\\\\\\\\\\\\|\\\\\\\\\\\\\\ \\\\\\\\\\\\\\(getenforce\\\\\\\\\\\\\\ \\\\\\\\\\\\\\|\\\\\\\\\\\\\\ grep\\\\\\\\\\\\\\ -i\\\\\\\\\\\\\\ --\\\\\\\\\\\\\\ disabled\\\\\\\\\\\\\\ \\\\\\\\\\\\\\&\\\\\\\\\\\\\\&\\\\\\\\\\\\\\ grep\\\\\\\\\\\\\\ -i\\\\\\\\\\\\\\ --\\\\\\\\\\\\\\ \\\\\\\\\\\\\\^SELINUX\\\\\\\\\\\\\\=disabled\\\\\\\\\\\\\\$\\\\\\\\\\\\\\ /etc/selinux/config\\\\\\\\\\\\\\)\\\\\\\\\\\\\\;\ 2\\>\\ /dev/null)
    end

    context 'without sudo' do
      before do
        set :salt_become_method, :none
      end

      it_should_behave_like 'builded simple command', \
                            %q(salt -L localhost --out=json cmd.run env='{"LANG":"C"}' shell='/bin/sh' test\\ -f\\ /etc/passwd\\;)
      it_should_behave_like 'builded complex command', \
                            %q(salt -L localhost --out=json cmd.run env='{"LANG":"C"}' shell='/bin/sh' test\\ \\!\\ -f\\ /etc/selinux/config\\ \\|\\|\\ \\(getenforce\\ \\|\\ grep\\ -i\\ --\\ disabled\\ \\&\\&\\ grep\\ -i\\ --\\ \\^SELINUX\\=disabled\\$\\ /etc/selinux/config\\)\\;)
    end
  end
end
# rubocop:enable Metrics/BlockLength, Layout/LineLength
