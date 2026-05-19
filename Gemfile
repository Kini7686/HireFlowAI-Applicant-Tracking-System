source "https://rubygems.org"

ruby "~> 3.2.0"

gem "rails", "~> 7.1.0"
gem "sprockets-rails"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "redis", "~> 5.0"
gem "connection_pool", "< 3"
gem "sidekiq", "~> 7.2"
gem "devise", "~> 4.9"
gem "pundit", "~> 2.3"
gem "image_processing", "~> 1.2"
gem "pdf-reader", "~> 2.12"
gem "ruby-openai", "~> 6.3"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails"
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails"
  gem "faker"
  gem "pundit-matchers"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end

group :production do
  gem "aws-sdk-s3", require: false
end
