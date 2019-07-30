# Easy scraping for the front page of Raleigh Craigslist
require 'nokogiri'
require 'mechanize'

def get_results_with_mechanize
  mechanize = Mechanize.new
  page = mechanize.get('https://raleigh.craigslist.org/search/ppa?query=TV')
  titles = page.search(".result-info").search(".result-title").children.map {|name| name.text }
  prices = page.search(".result-info").search(".result-price").children.map {|price| price.text }
end

# TODO: generate CSV of tvs under $200 on Craigslist
# CSV.open("tvs.csv", "wb") do |csv|
# end
