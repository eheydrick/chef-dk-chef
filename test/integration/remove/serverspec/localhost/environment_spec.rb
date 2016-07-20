# Encoding: UTF-8

require_relative '../spec_helper'

describe 'chef-dk::remove::environment' do
  shared_examples_for 'file without chef shell-init' do
    it 'does not contain the chef shell-init command' do
      matcher = /^eval "\$\(chef shell-init bash\)"$/
      expect(subject.content).to_not match(matcher)
    end
  end

  describe file('/etc/bashrc'),
           if: %w(darwin redhat fedora).include?(os[:family]) do
    it_behaves_like 'file without chef shell-init'
  end

  describe file('/etc/bash.bashrc'),
           if: %w(ubuntu debian).include?(os[:family]) do
    it_behaves_like 'file without chef shell-init'
  end

  describe file('/opt/chefdk/embedded/bin/rubygems-cabin-test'),
           if: os[:family] != 'windows' do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end

  describe file(
    '~/AppData/Local/chefdk/gem/ruby/2.1.0/bin/rubygems-cabin-test'
  ), if: os[:family] == 'windows'  do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end
end
