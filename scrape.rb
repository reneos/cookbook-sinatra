require "nokogiri"
require "open-uri"

class Scrape
  def self.call(url)
    website = open(url)
    doc = Nokogiri::HTML(website)
    doc.search(".node-recipe").first(5)
  end
end
