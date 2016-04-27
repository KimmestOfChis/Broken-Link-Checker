require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'gmail'
require 'spreadsheet'

urlFile = File.open('urlFiles.txt', 'r')
contents = urlFile.read
$myUrl = contents.split(' ')

startTime = Time.new

puts "URL's running through this script: #{$myUrl.length}"

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

driver = Selenium::WebDriver.for :firefox #easiest browser to run this test script on
driver.navigate.to "http://webpagetest.org"

driver.find_element(:id, "advanced_settings").click
numberofTests = driver.find_element(:id, "number_of_tests")
numberofTests.click
numberofTests.clear #clears the default text in the form so that the site properly runs the URL
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

checkData = data.at_css('average')

if checkData == 'The test completed but there were no successful results.'
  driver.find_element(:name => 'Re-run the test').click
end

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

hash.each do |site, item|
  $stuff = "For site: #{site}, \n
 Load Time: #{item[0]} | First Byte: #{item[1]} | Start Render Time: #{item[2]} | Number of DOM Elements: #{item[3]}\n
 Document Complete Time: #{item[4]} | Document Complete Requests: #{item[5]} | Document Complete Bytes In: #{item[6]}\n
 Fully Loaded Time: #{item[7]} | Fully Loaded Requests: #{item[8]} | Fully Loaded Bytles In: #{item[9]} | Cost:#{item[10]}\n"
  end
   
 

book.write '/Users/matthewjohnson/Documents/projects/404projects/firstptest.xls'

endTime = Time.new
totalTime = endTime - startTime
puts "Data Extraction Process took #{totalTime} seconds to complete."

puts "What is your email?"
$email = gets.chomp

puts "What is your password?"
$password = gets.chomp

puts "What is the name of the person you're sending this email to?"
recipient = gets.chomp

puts "What is the email address you're sending this to?"
$recipientEmail = gets.chomp

$body = "Hey #{recipient}! I ran the Web Page Performance Data Extractor for #{hash.length} URL's. The results are as follows: \n\n " +$stuff+ "
\n Sincerely, \n
Matthew A. Johnson"

def email()
  gmail = Gmail.connect($email , $password)
  gmail.deliver do
    to $recipientEmail
    subject "Web Page Performance Data Extractor Results"
    text_part do
      body $body
    end
    #add_file 'results.txt'
  end
  gmail.logout
end

email()

