# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'codebreaker_PI'
gem 'haml'
gem 'i18n'

group :development do
  gem 'pry'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'rubocop', '~> 0.60.0', require: false
  gem 'rubocop-rspec'
  gem 'simplecov', require: false, group: :test
  gem 'simplecov-lcov'
end
