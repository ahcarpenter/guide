# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0'
gem 'pg', '~> 1.2'
gem 'puma', '~> 4.1'
gem 'bootsnap', '~> 1.4', require: false
gem 'dry-transaction', '0.13.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :test do
  gem 'rspec', '~> 3.9'
end

group :development do
  gem 'listen', '~> 3.1'
  gem 'rubocop', '0.79.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
