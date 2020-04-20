require "nokogiri"
require "open-uri"
require_relative "recipe"

class Parse
  def self.call(search_results)
    return [] if search_results.all?(&:nil?)

    search_results.map do |recipe|
      title = recipe.search("h3").text.strip
      description = recipe.search(".teaser-item__text-content").text.strip
      prep_time = recipe.search(".teaser-item__info-item--total-time").text.strip
      difficulty = recipe.search(".teaser-item__info-item--skill-level").text.strip
      Recipe.new(title, description, prep_time, difficulty)
    end
  end
end
