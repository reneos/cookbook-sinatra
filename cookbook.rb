require_relative 'recipe'
require 'csv'

class Cookbook
  CSV_OPTIONS = { col_sep: ',', encoding: 'UTF-8', force_quotes: true, quote_char: '"' }
  def initialize(csv_file_path)
    @recipes = []
    @csv_file = csv_file_path
    add_recipes_from_csv
  end

  def add_recipes_from_csv
    # Title, descr, prep time, difficulty, done?
    CSV.foreach(@csv_file, CSV_OPTIONS) do |row|
      done = row[4] == "true"
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], done)
    end
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    rewrite_csv
  end

  def recipe_to_array(recipe)
    [recipe.name, recipe.description, recipe.prep_time, recipe.difficulty, recipe.done?]
  end

  def rewrite_csv
    CSV.open(@csv_file, 'wb', CSV_OPTIONS) do |row|
      @recipes.each do |recipe|
        row << recipe_to_array(recipe)
      end
    end
  end

  def remove_recipes(indices)
    # Takes an array of indices
    @recipes.delete_if.with_index { |_recipe, index| indices.include?(index) }
    rewrite_csv
  end

  def mark_done(recipe_index)
    @recipes[recipe_index].mark_done
  end
end
