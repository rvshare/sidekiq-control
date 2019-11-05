# frozen_string_literal: true

RSpec.describe Sidekiq::Control do
  it 'has a version number' do
    expect(Sidekiq::Control::VERSION).not_to be nil
  end
end
