source 'https://rubygems.org'

ruby '2.3.0'
gem 'rails', '5.0'
#gem 'rails', github: "rails/rails"
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'json'
#needs to be changed to official master as soon as rails 5 is supported
gem 'godmin',  github: "agileventures/godmin" 
gem 'godmin-tags'
gem 'apipie-rails'
gem 'rack-cors', require: 'rack/cors'
gem 'acts-as-taggable-on', :git => 'https://github.com/mbleigh/acts-as-taggable-on'
gem 'devise'#, github: "plataformatec/devise"
gem 'simple_token_authentication', '~> 1.0'
#gem 'simple_token_authentication', git: 'https://github.com/gonzalo-bulnes/simple_token_authentication.git', branch: 'spike-add-rails-5-support-without-backward-compatibility-breakage', ref: '090ad57392b06fa1defbb70e8faa04fda99d5db1'
#getting rid of the deprecation warnings
#gem 'simple_token_authentication', github: "fighterii/simple_token_authentication", branch: 'spike-add-rails-5-support-without-backward-compatibility-breakage'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'geocoder'
gem 'fb_graph2'
gem 'mailboxer',github: 'mailboxer/mailboxer'
gem 'friendly_id', '~> 5.0.0'
gem 'amistad'
#gem 'puma'

group :development, :test do
  gem 'coveralls', require: false
  gem 'simplecov', github: 'AgileVentures/simplecov'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', "3.5.0.beta2"
  gem 'rails-controller-testing'
  #gem 'rspec-core', git: "https://github.com/rspec/rspec-core.git", branch: "master"
  #gem 'rspec-support', git: "https://github.com/rspec/rspec-support.git", branch: "master"
  #gem 'rspec-expectations', git: "https://github.com/rspec/rspec-expectations.git", branch: "master"
  #gem 'rspec-mocks', git: "https://github.com/rspec/rspec-mocks.git", branch: "master"
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'faker'
  gem 'cucumber'
  
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'listen' 
end

group :test do
  #gem 'cucumber'
  #cucumber-rails just generator for cucumber tests, atm not supporting rails-5
  #gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor'
end
