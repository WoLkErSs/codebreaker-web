# frozen_string_literal: true
ruby '2.4.5'

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'codebreaker_PI'
gem 'i18n'
gem 'rack'
gem 'haml'

group :development do
  gem 'pry'
  gem 'rubocop', '~> 0.60.0', require: false
  gem 'rubocop-rspec'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'simplecov', require: false, group: :test
  gem 'simplecov-lcov'
end
