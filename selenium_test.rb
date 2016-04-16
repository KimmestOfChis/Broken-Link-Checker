require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

urlFile = File.open('urlFiles.txt', 'r')
contents = urlFile.read
myUrl = contents.split(' ')

myUrl.each do |site|

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://webpagetest.org"

driver.find_element(:id, "advanced_settings").click
numberofTests = driver.find_element(:id, "number_of_tests")
numberofTests.clear
numberofTests.send_keys "9"
driver.find_element(:id, "viewBoth").click

websiteTest = driver.find_element(:id, 'url')
websiteTest.send_keys site
websiteTest.submit

currentUrl = driver.current_url

wait = Selenium::WebDriver::Wait.new(:timeout => 1000)

begin
	websiteTest = wait.until { driver.find_element(:css => "#fvLoadTime") }
end


data = Nokogiri::HTML(open(currentUrl))
puts data.at_css('#fvLoadTime').text.strip
puts data.at_css('#fvTTFB').text.strip
puts data.at_css('#fvStartRender').text.strip
#puts data.at_css('#fvVisual').text.strip     Not sure what is going on, will return to later... Seems this data point is not available on everytest...
puts data.at_css('#fvDomElements').text.strip
puts data.at_css('#fvDocComplete').text.strip
puts data.at_css('#fvRequestsDoc').text.strip
puts data.at_css('#fvBytesDoc').text.strip
puts data.at_css('#fvFullyLoaded').text.strip
puts data.at_css('#fvRequests').text.strip
puts data.at_css('#fvBytes').text.strip
puts data.at_css('#fvCost').text.strip

driver.quit

end