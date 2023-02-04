# coding: utf-8
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Specinfra::SaltBackend do
  it 'has a version number' do
    expect(Specinfra::SaltBackend::VERSION).not_to be nil
  end
end
