require 'anemone'
require 'uri'

pager = []

puts "What site would you like to search?" #add future regex corrections, and REP obeyance 
$webSite = gets.chomp

$webSite.strip()

$webSite = "http://www.#{$webSite}.com"



puts "What depth do you want to set this crawler to?"
depth = gets.chomp

$setDepth = depth.to_i

startTime = Time.now
  	puts "Test started at " + startTime.to_s #Start time


Anemone.crawl($webSite , :depth_limit => $setDepth) do |anemone|
  anemone.on_every_page do |page|
  	puts page.url
pager.push(page.url)
end
end

puts "Test completed at #{Time.now}"
totalTime = Time.now - startTime
if totalTime <= 60
	puts "#{totalTime} seconds elapsed for test."
else
puts "Total elapsed for test: #{totalTime.to_i/60} minutes."
end

puts "#{pager.length.to_s} pages indexed."

urlSet = pager.join(' ')
fname = 'urlFiles.txt'
filer = File.open(fname, 'w')
filer.puts urlSet
filer.close