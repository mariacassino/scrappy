# Scraping the front page of Raleigh Craigslist w/ Net::HTTP, HTTParty, & Nokogiri

require 'pry'
require 'net/http'
require 'uri'
require 'httparty'
require 'nokogiri'


def craigslist_url
  "https://raleigh.craigslist.org/search/ppa?max_price=200"
end


# def headers #cookie
#   response = HTTParty.get(craigslist_url)
#   cookie = response.headers["set-cookie"]
#   headers = {
#     "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
#     "Accept-Encoding" => "gzip, deflate, br",
#     "Accept-Language" => "en-US,en;q=0.9,la;q=0.8",
#     "Cache-Control" => "max-age=0",
#     "Connection" => "keep-alive",
#     "Cookie" => cookie,
#     "Host" => "raleigh.craigslist.org",
#     "If-Modified-Since" => "Tue, 30 Jul 2019 15:42:39 GMT",
#     "Referer" => "https://raleigh.craigslist.org/search/ppa?query=tv",
#     "Upgrade-Insecure-Requests" => "1",
#     "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
#   }
#   return headers
#   # byebug
# end



def get_results #headers
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
  request["Referer"] = "https://raleigh.craigslist.org/search/ppa?max_price=200"
  request["Upgrade-Insecure-Requests"] = "1"
  request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"

  # request["Host"] = "raleigh.craigslist.org"
  # request["Connection"] = "keep-alive"
  # request["Cache-Control"] = "max-age=0"
  # request["Upgrade-Insecure-Requests"] = "1"
  # request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
  # request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"
  # request["Referer"] = "https://raleigh.craigslist.org/search/ppa?query=crt+tv"
  # request["Accept-Encoding"] = "gzip, deflate, br"
  # request["Accept-Language"] = "en-US,en;q=0.9,la;q=0.8"
  # If-Modified-Since: Tue, 30 Jul 2019 15:42:39 GMT

  req_options = {
    use_ssl: uri.scheme == "https",
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    res = http.request(request)
  end
  html_response = Zlib::GzipReader.new(StringIO.new(response.body), encoding: "ASCII-8BIT").read
  parse_page = Nokogiri::HTML(html_response)
  titles = parse_page.css(".content").css("ul.rows").css("li.result-row").css(".result-title").children.map {|name| name.text }.compact
  byebug
  titles
end


# def cookie#(response)
#   response = HTTParty.get(craigslist_url)
#   cookie = response.headers["set-cookie"]
# end


# def get_javax(response)
#   parse_page = Nokogiri::HTML(response)
#   byebug
#   javax = parse_page.at('input[@name="javax.faces.ViewState"]')['value']
#   javax = parse_page.at('input[@id="shop-location-input"]')['value']
# end

#
#
#   def search_by_case_number(cookie, javax)
#     # uri = URI.parse(court_url)
#     uri = URI.parse(craigslist_url)
#     request = Net::HTTP::Post.new(uri)
#     request.content_type = "application/x-www-form-urlencoded"
#     request["Cookie"] = cookie
#     request["Origin"] = "https://www.dccourts.gov"
#     request["Origin"] = "https://www.craigslist.com"
#     request["Accept-Language"] = "en-US,en;q=0.8"
#     request["Upgrade-Insecure-Requests"] = "1"
#     request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
#     request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
#     request["Cache-Control"] = "max-age=0"
#     request["Referer"] = "https://www.dccourts.gov/cco/maincase.jsf"
#     request["Connection"] = "keep-alive"
#     request.set_form_data(
#       "appData:searchform" => "appData:searchform",
#       "appData:searchform:searchPanelCollapsedState" => "false",
#       "appData:searchform:jspsearchpage:lastName" => "",
#       "appData:searchform:jspsearchpage:companyName" => "",
#       "appData:searchform:jspsearchpage:firstName" => "",
#       "appData:searchform:jspsearchpage:j_id_id14pc3" => "2017",
#       "appData:searchform:jspsearchpage:selectCaseType" => "CF2",
#       "appData:searchform:jspsearchpage:j_id_id18pc3" => "001225",
#       "appData:searchform:jspsearchpage:nameAttributesPanelCollapsedState" => "true",
#       "appData:searchform:jspsearchpage:submitSearch.x" => "48",
#       "appData:searchform:jspsearchpage:submitSearch.y" => "15",
#       "javax.faces.ViewState" => javax,
#       )
#
#     req_options = {
#       use_ssl: uri.scheme == "https",
#     }
#
#     response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
#       http.request(request)
#     end
#   end
#
#
#   def select_case(cookie, javax)
#     uri = URI.parse('https://www.dccourts.gov/cco/maincase.jsf')
#     request = Net::HTTP::Post.new(uri)
#     request.content_type = "application/x-www-form-urlencoded"
#     request["Cookie"] = cookie
#     request["Origin"] = "https://www.dccourts.gov"
#     request["Accept-Language"] = "en-US,en;q=0.8"
#     request["Upgrade-Insecure-Requests"] = "1"
#     request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
#     request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
#     request["Cache-Control"] = "max-age=0"
#     request["Referer"] = "https://www.dccourts.gov/cco/maincase.jsf"
#     request["Connection"] = "keep-alive"
#     request.set_form_data(
#       "appData:resultsform" => "appData:resultsform",
#       "appData:resultsform:resultsPanelCollapsedState" => "false",
#       "appData:resultsform:jspresultspage:dt1:0:selectEntryOption" => "true",
#       "appData:resultsform:jspresultspage:dt1:j_id_id41pc5.x" => "85",
#       "appData:resultsform:jspresultspage:dt1:j_id_id41pc5.y" => "12",
#       "javax.faces.ViewState" => javax,
#       )
#
#     req_options = {
#       use_ssl: uri.scheme == "https",
#     }
#
#     startTime = Time.now
#     response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
#       http.request(request)
#     end
#   end
#
#
#   def get_dockets(response)
#     parse_page = Nokogiri::HTML(response.body)
#
#     columns = parse_page.xpath('//*[@id="appData:detailsform:jspdetailspage:docketInfo:DocketsInfo"]/thead')
#     # rows = parse_page.css('table#appData:detailsform:jspdetailspage:docketInfo:DocketsInfo tr')
#     details = columns.collect do |column|
#       detail = {}
#       [
#         [:docket_date, '//*[@id="appData:detailsform:jspdetailspage:docketInfo:DocketsInfo:tbody_element"]/tr[1]/td[1]'],
#         [:description, '//*[@id="appData:detailsform:jspdetailspage:docketInfo:DocketsInfo:tbody_element"]/tr[1]/td[2]'],
#         [:messages, '//*[@id="appData:detailsform:jspdetailspage:docketInfo:DocketsInfo:tbody_element"]/tr[1]/td[3]'],
#       ].each do |name, xpath|
#         detail[name] =  column.at_xpath(xpath).to_s[/\>(.*)</,1]
#       end
#       detail
#     end
#     pp details
#   end
#
#
# response = HTTParty.get(craigslist_url)
# cookie = cookie #response
results = get_results #headers
byebug
results
# case_results = search_by_case_number(cookie, javax)
# response = case_results.body
# javax = get_javax(response)
# response = select_case(cookie, javax)
# get_dockets(response)
