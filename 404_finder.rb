require 'open-uri'
require 'net/http'
require 'gmail'

urlFile = File.open('urlFiles.txt', 'r') #ural.txt is the file being used by creator to test the functionality of this code

contents = urlFile.read

urlTest = contents.split(' ')

puts "How many URL's would you like to test?"

testReq = gets.chomp

if testReq.to_i == 0 
	puts "No items to be tested. Check that you've entered a numerical value."
	abort()
end

urlTest = urlTest.first(testReq.to_i)

#Runs Test for Malformed URLS and sorts untestable and testable into their own respective arrays
malformedExpressions = []
goodURLs = []
dontRun = []
regex = /https?:\/\//
regDR = /#/
urlTest.each do |i|
if regDR.match(i) != nil
	dontRun.push(i)
elsif regex.match(i) == nil
malformedExpressions.push(i)
else
	goodURLs.push(i)
end
end

#Removes any whitespace that may occur due to accidental user input
goodURLs.each do |i|
	i.strip
end


puts goodURLs.length.to_s + " URL's are being checked with this test. " + malformedExpressions.length.to_s + " were found to be untestable due to inproper user input. " +dontRun.length.to_s + " were exempted from this test."

informationalURL = []
successfulURL = []
redirectionURL = []
clientError = []
serverError = []
brokenURL = []




goodURLs.each do |i|
	uri = URI(i)
	res = Net::HTTP.get_response(uri)
	if res.code >= '100' && res.code < '200'
	informationalURL.push(i)
elsif res.code >= '200' && res.code < '300'
	successfulURL.push(i)
elsif res.code >= '300' && res.code < '400'
	redirectionURL.push(i)
elsif res.code >= '400' && res.code != '404' && res.code < '500'
	clientError.push(i)
elsif res.code >= '500' && res.code < '600'
	serverError.push(i)
else 
	brokenURL.push(i)
end
end


if informationalURL.length == 0
	puts "No informational URL's were found."
else
	puts informationalURL.length.to_s + " item(s) determined to be informational."
end

if successfulURL.length == 0
	puts "No succesful URL's were found."
else
	puts successfulURL.length.to_s + " item(s) were successful URL's with a 200 code."
end

if redirectionURL.length == 0
	puts "No redirection URL's found."
else
	puts redirectionURL.length.to_s + " item(s) redirected to another site."
end

if clientError.length == 0
	puts "No client errors found."
else
	puts clientError.length.to_s + " item(s) were determined to have client errors."
end

if serverError.length == 0
	puts "No server-side errors found"
else
	puts serverError.length.to_s + " item(s) were determined to have server errors."
end

if brokenURL.length == 0
	puts "No 404 errors found"
	else
		puts brokenURL.length.to_s + " item(s) yielded 404 Broken Link Errors!"
	end

publishResults = 'Hey Dan! I\'ve created the 404 finder as you asked. Here are the results: 
We ran ' + goodURLs.length.to_s + ' URL\'s with this test.
There were ' + informationalURL.length.to_s + ' URL\'s were informational in nature. 
There were ' + successfulURL.length.to_s + ' URL\'s worked as intended. 
There were ' + redirectionURL.length.to_s + ' URL\'s redirected to some other site.
There were ' + clientError.length.to_s + ' URL\'s that were not functional due to client side errors.
There were ' + serverError.length.to_s + ' URL\'s that were not functional due to server side errorss.
Most importantly: There\'s ' + brokenURL.length.to_s + ' in the set you provided. Here are the 404 error URL\'s: ' + brokenURL.to_s +

'Good day!
Matthew Johnson'

fileName = 'results.txt'
resultsFile = File.open(fileName, 'w')
resultsFile.puts publishResults
resultsFile.close

	def email()
  gmail = Gmail.connect('memjay3279@gmail.com', 'bigemjay2008')
  gmail.deliver do
    to 'mj128508@gmail.com'
    subject "Broken Links Test"
    text_part do
      body "Hey (recipient)! I've attached a file to this email called \"results.txt\" to this email with the results inside. Call me if you have any questions at (740)-248-6734."
    end
    add_file 'results.txt'
  end
  gmail.logout
end

email()