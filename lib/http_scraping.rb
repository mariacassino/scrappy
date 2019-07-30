# Scraping the front page of Raleigh Craigslist w/ Net::HTTP, HTTParty, & Nokogiri
require 'pry'
require 'net/http'
require 'uri'
require 'httparty'
require 'nokogiri'

def get_results
  craigslist_url = "https://raleigh.craigslist.org/search/ppa?query=tv&max_price=200"
  resp = HTTParty.get(craigslist_url)
  cookie = resp.headers["set-cookie"]
  uri = URI.parse(craigslist_url)
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
  request["Accept-Encoding"] = "gzip, deflate, br"
  request["Accept-Language"] = "en-US,en;q=0.9,la;q=0.8"
  request["Cache-Control"] = "max-age=0"
  request["Connection"] = "keep-alive"
  request["Cookie"] = cookie
  request["Host"] = "raleigh.craigslist.org"
  request["If-Modified-Since"] = "Tue, 30 Jul 2019 15:42:39 GMT"
  request["Referer"] = "https://raleigh.craigslist.org/search/ppa?query=tv&max_price=200"
  request["Upgrade-Insecure-Requests"] = "1"
  request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    res = http.request(request)
  end
  html_response = Zlib::GzipReader.new(StringIO.new(response.body), encoding: "ASCII-8BIT").read
  parse_page = Nokogiri::HTML(html_response)
  titles = parse_page.css(".content").css("ul.rows").css("li.result-row").css(".result-info").css(".result-title").children.map {|name| name.text }.compact
  prices = parse_page.css(".content").css("ul.rows").css("li.result-row").css(".result-info").css(".result-price").children.map {|price| price.text }.compact

  # TODO: generate CSV of tvs under $200 on Craigslist
  # CSV.open("tvs.csv", "wb") do |csv|
  # end
end


results = get_results
puts results
