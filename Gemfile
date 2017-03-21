source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
gem 'sqlite3', group: [:development, :test]
gem 'pg', group: :production
gem 'puma', '~> 3.0'

gem 'thor', '0.19.1'
gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
