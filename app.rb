require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "recipe"
require_relative "cookbook"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  # List all recipes
  # Link to page to add new recipe
  @recipes = cookbook.all
  erb :index
end

get '/add' do
  erb :add
end

post '/recipes' do
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time].to_i, params[:difficulty])
  cookbook.add_recipe(recipe)
  redirect "/"
end

get '/delete/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect "/"
end
