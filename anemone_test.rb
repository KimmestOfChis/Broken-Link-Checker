require 'anemone'
require 'uri'

pager = []

startTime = Time.now
  	puts "Test started at" + startTime.to_s #Start time


Anemone.crawl("http://www.trektoday.com/" , :depth_limit => 3) do |anemone|
  anemone.on_every_page do |page|
  	puts page.url
pager.push(page.url)
end
end

puts "Test completed at #{Time.now}"
  	totalTime = Time.now - startTime
  	puts "Total elapsed for test: #{totalTime} seconds." #Start Time in Minutes

urlSet = pager.join(' ')
fname = 'urlFiles.txt'
filer = File.open(fname, 'w')
filer.puts urlSet
filer.close
