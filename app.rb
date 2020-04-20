require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'parse'
require_relative 'scrape'
require_relative "recipe"
require_relative "cookbook"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
  erb :index
end
