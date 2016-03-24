ENV['RAILS_ENV'] ||= 'test'
require 'coveralls'
require 'simplecov'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
Coveralls.wear_merged!
require File.expand_path('../../config/environment', __FILE__)
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require 'vcr'

ActiveRecord::Migration.maintain_test_schema!


VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { record: :once  }
  c.allow_http_connections_when_no_cassette = true
end

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow_localhost: true)
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include FactoryGirl::Syntax::Methods
  config.include ResponseJSON
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip 
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
      VCR.use_cassette(name, options, &example)
    end
  end
  
  config.before(:each) do
    WebMock.stub_request(:get, /graph.facebook.com/).
        to_return(status: 200)
  end
end

OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                  provider: 'facebook',
                                                                  uid: '123545',
                                                                  info: {
                                                                      first_name: 'Thomas',
                                                                      last_name:  'Ochman',
                                                                      email:      'thomas@craft.com'
                                                                  },
                                                                  credentials: {
                                                                      token: '1234567890',
                                                                      expires_at: Time.now + 1.week
                                                                  }
                                                              })