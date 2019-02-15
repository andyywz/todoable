require "bundler/setup"
require "todoable"
require "webmock/rspec"
require "vcr"
require "byebug"

# Disable external requests
WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'

  config.hook_into :webmock

  config.default_cassette_options = {
    allow_playback_repeats: true
  }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
