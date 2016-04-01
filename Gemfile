source 'https://rubygems.org'

ruby '2.3.0'
gem 'rails', '5.0.0.beta3'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'json'
gem 'godmin', github: "agileventures/godmin"
gem 'godmin-tags'
gem 'apipie-rails'
gem 'rack-cors', require: 'rack/cors'
gem 'acts-as-taggable-on'
gem 'devise', github: "plataformatec/devise"
#gem 'simple_token_authentication', '~> 1.0'
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
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'faker'
  gem 'listen'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
end

group :test do
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end
