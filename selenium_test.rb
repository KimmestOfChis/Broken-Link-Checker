require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'gmail'

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
websiteTest.clear
websiteTest.send_keys site
websiteTest.submit

currentUrl = driver.current_url

wait = Selenium::WebDriver::Wait.new(:timeout => 1000)

begin
	websiteTest = wait.until { driver.find_element(:css => "#fvLoadTime") }
end


data = Nokogiri::HTML(open(currentUrl))
$loadTime = data.at_css('#fvLoadTime').text.strip
$firstByte = data.at_css('#fvTTFB').text.strip
$startRender = data.at_css('#fvStartRender').text.strip
#$speedIndex =('#fvVisual').text.strip     Not sure what is going on, will return to later... Seems this data point is not available on everytest...
$numdomElements = data.at_css('#fvDomElements').text.strip
$docComplete = data.at_css('#fvDocComplete').text.strip
$requests = data.at_css('#fvRequestsDoc').text.strip
$bytesIn = data.at_css('#fvBytesDoc').text.strip
$fullyLoaded = data.at_css('#fvFullyLoaded').text.strip
$flRequests = data.at_css('#fvRequests').text.strip
$flBytesin = data.at_css('#fvBytes').text.strip
$cost = data.at_css('#fvCost').text.strip

pageResults = "For #{site}, 
	\n Load Time: #{$loadTime}.
	\n First Byte: #{$firstByte}
	\n Start Render: #{$startRender}
	\n DOM Elements: #{$numdomElements}
	\n Document Complete Time: #{$docComplete}
	\n Document Complete Requests: #{$requests}
	\n Bytes In: #{$bytesIn}
	\n Fully Loaded Time #{$fullyLoaded}
	\n Fully Loaded Requests: #{$flRequests}
	\n Fully Loaded Bytes In: #{$flBytesin}
	\n Cost: #{$cost}"


puts pageResults

end

#puts "What is the sender email?"
#$email = gets.chomp

#puts "What is the sender email's password?"
#$password = gets.chomp

#puts "Who are you sending this email to?"
#$recipientEmail = gets.chomp

puts $scraperResults

def email()
  gmail = Gmail.connect('memjay3279@gmail.com' , 'bigemjay2008') 
  gmail.deliver do
    to 'joshkempcoaching@gmail.com'
    subject "Scraper Results"
    text_part do
      body "Hey Josh, this is a really crude printout of the results. I'll have something much prettier soon! " + $scraperResults
  end
   #add_file
   end
  gmail.logout
end 

email()