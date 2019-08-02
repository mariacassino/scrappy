# SCRAPPY

Two simple Craigslist web scrapers Written with Ruby 2.5.5 on Rails 5.

Running `lib/http_scraping` uses HTTParty to retrieve the site cookie, & a Net::HTTP request containing the site headers & cookie returns a gzip response that is read by Zlib & then parsed by Nokogiri. Ruby takes the parsed objects & arranges them into arrays.

Running `lib/mechanize_scraping` showcases a way to implement Mechanize to do most of the work for you.

TODO: Iterate through arrays containing, in this case, item names and prices from Craigslist, and add/export them to a CSV.
