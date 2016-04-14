require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

myUrl = "http://www.google.com"

testerUrl = "http://webpagetest.org"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to testerUrl

element = driver.find_element(:id, 'url')
element.send_keys myUrl
element.submit

url = driver.current_url

wait = Selenium::WebDriver::Wait.new(:timeout => 1000)
begin
	element = wait.until { driver.find_element(:css => "#fvLoadTime") }
ensure
	driver.quit
end

data = Nokogiri::HTML(open(url))

#First View Data

puts data.at_css('#fvLoadTime').text.strip
puts data.at_css('#fvTTFB').text.strip
puts data.at_css('#fvStartRender').text.strip
puts data.at_css('#fvVisual').text.strip
puts data.at_css('#fvDomElements').text.strip
puts data.at_css('#fvDocComplete').text.strip
puts data.at_css('#fvRequestsDoc').text.strip
puts data.at_css('#fvBytesDoc').text.strip
puts data.at_css('#fvFullyLoaded').text.strip
puts data.at_css('#fvRequests').text.strip
puts data.at_css('#fvBytes').text.strip
puts data.at_css('#fvCost').text.strip


