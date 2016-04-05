require 'anemone'
require 'uri'

pager = []

startTime = Time.now
  	puts "Test started at" + startTime.to_s

Anemone.crawl("http://www.trektoday.com/" , :depth_limit => 1) do |anemone|
  anemone.on_every_page do |page|
  	puts page.url
 
pager.push(page.url)
end
end

puts "Test completed at #{Time.now}"
  	totalTime = Time.now - startTime
  	puts "Total elapsed for test: #{totalTime} seconds."

urlSet = pager.join(' ')
fname = 'urlFiles.txt'
filer = File.open(fname, 'w')
filer.puts urlSet
filer.close
