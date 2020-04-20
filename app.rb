require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "recipe"
require_relative "cookbook"
require_relative "scrape"
require_relative "parse"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)
bbc_search_results = []
URL = "https://www.bbcgoodfood.com/search/recipes?query="

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/add' do
  erb :add
end

post '/recipes' do
  recipe = Recipe.new(params[:name], params[:description].encode(universal_newline: true), params[:prep_time] + " mins", params[:difficulty])
  cookbook.add_recipe(recipe)
  redirect "/"
end

get '/delete/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect "/"
end

get '/recipe/:index' do
  index = params[:index].to_i
  @recipe = cookbook.all[index]
  erb :recipe
end

post '/change' do
  checked = params[:checked]
  if checked && params[:action] == "mark"
    mark_as_done(checked, cookbook)
  elsif checked && params[:action] == "delete"
    delete(checked, cookbook)
  end
  redirect '/'
end

get '/search_bbc' do
  @ingredient = params[:ingredient]
  @recipes = import(URL, @ingredient)
  bbc_search_results = @recipes
  erb :results
end

post '/import_recipe' do
  checked = params[:checked]
  if checked
    checked.each { |index| cookbook.add_recipe(bbc_search_results[index.to_i]) }
  end
  redirect '/'
end

def import(url, ingredient)
  search_results = Scrape.call(url + ingredient)
  Parse.call(search_results)
end

def mark_as_done(checked, cookbook)
  checked.each do |index|
    cookbook.mark_done(index.to_i)
  end
end

def delete(checked, cookbook)
  checked = checked.map(&:to_i)
  cookbook.remove_recipes(checked)
end
