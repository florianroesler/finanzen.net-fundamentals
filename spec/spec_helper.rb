require 'vcr'
require 'webmock/rspec'
require 'require_all'
require_all 'lib'

VCR.configure do |config|
  config.cassette_library_dir = 'vcr'
  config.hook_into :webmock
end
