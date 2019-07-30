# Easy scraping for the front page of Raleigh Craigslist

require 'net/http'
require 'uri'
require 'httparty'
require 'nokogiri'
require 'mechanize'


doc = HTTParty.get("https://raleigh.craigslist.org/search/ppa?query=TV")
parse_page = Nokogiri::HTML(doc)
names = parse_page.css(".content").css("ul.rows").css("li.result-row").css(".result-title").children.map {|name| name.text }.compact
