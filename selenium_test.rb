require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'gmail'
require 'spreadsheet'

urlFile = File.open('urlFiles.txt', 'r')
contents = urlFile.read
$myUrl = contents.split(' ')

$siteName = []
$loadTime = []
$firstByte = []
$startRender = []
$numdomElements = []
$docComplete = []
$requests = []
$bytesIn = []
$fullyLoaded = []
$flRequests = []
$flBytesin = []
$cost = []

$myUrl.each do |site|

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

wait = Selenium::WebDriver::Wait.new(:timeout => 100000)

begin
	websiteTest = wait.until { driver.find_element(:css => "#fvLoadTime") }
end

data = Nokogiri::HTML(open(currentUrl))

$siteName.push(site)
$loadTime.push(data.at_css('#fvLoadTime').text.strip)
$firstByte.push(data.at_css('#fvTTFB').text.strip)
$startRender.push(data.at_css('#fvStartRender').text.strip)
$numdomElements.push(data.at_css('#fvDomElements').text.strip)
$docComplete.push(data.at_css('#fvDocComplete').text.strip)
$requests.push(data.at_css('#fvRequestsDoc').text.strip)
$bytesIn.push(data.at_css('#fvBytesDoc').text.strip)
$fullyLoaded.push(data.at_css('#fvFullyLoaded').text.strip)
$flRequests.push(data.at_css('#fvRequests').text.strip)
$flBytesin.push(data.at_css('#fvBytes').text.strip)
$cost.push(data.at_css('#fvCost').text.strip)


driver.quit
end

zipMe = $loadTime.zip($firstByte, $startRender, $numdomElements, $docComplete, $requests, $bytesIn, $fullyLoaded, $flRequests, $flBytesin, $cost)
hash = Hash[$siteName.zip(zipMe)]

puts hash

book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet :name => 'First Performance Report'



hash.each do |site, array|
  sheet1.row(1).push site
  sheet1.row(2).push array[0]
  sheet1.row(3).push array[1]
  sheet1.row(4).push array[2]
  sheet1.row(5).push array[3]
  sheet1.row(6).push array[4]
  sheet1.row(7).push array[5]
  sheet1.row(8).push array[6]
  sheet1.row(9).push array[7]
  sheet1.row(10).push array[8]
  sheet1.row(12).push array[9]
  sheet1.row(12).push array[10]
end

book.write '/Users/matthewjohnson/Documents/projects/404projects/firstptest.xls'

#puts "What is the sender email?"
#$email = gets.chomp

#puts "What is the sender email's password?"
#$password = gets.chomp

#puts "Who are you sending this email to?"
#$recipientEmail = gets.chomp
