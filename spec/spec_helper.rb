# coding: utf-8
# frozen_string_literal: true

require 'bundler/setup'
require 'specinfra'
require 'specinfra/helper/set'
require 'specinfra/backend/salt'

include Specinfra::Helper::Set # rubocop:disable Style/MixinUsage

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # reset `salt_*` options before each tests.
  config.before(:each) do
    %w[salt_user
       salt_become_method
       salt_sudo_user
       salt_sudo_password
       salt_sudo_path
       salt_su_user
       salt_su_password
       salt_su_path].each do |option|
      Specinfra.configuration.instance_variable_set("@#{option}", nil)
    end
  end
end
