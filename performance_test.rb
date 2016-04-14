require 'open-uri'
require 'nokogiri'

url = 'http://www.webpagetest.org/result/160413_KE_1CHM/'

data = Nokogiri::HTML(open(url))

#First View Data

puts data.at_css('#fvLoadTime').text.strip
puts data.at_css('#fvTTFB').text.strip
puts data.at_css('#fvStartRender').text.strip
puts data.at_css('#fvVisual').text.strip
puts data.at_css('#fvUserTime').text.strip
puts data.at_css('#fvDomElements').text.strip
puts data.at_css('#fvDocComplete').text.strip
puts data.at_css('#fvRequestsDoc').text.strip
puts data.at_css('#fvBytesDoc').text.strip
puts data.at_css('#fvFullyLoaded').text.strip
puts data.at_css('#fvRequests').text.strip
puts data.at_css('#fvBytes').text.strip
puts data.at_css('#fvCost').text.strip


classCheck = data.at_css('#fvLoadTime').text.strip
puts classCheck.class