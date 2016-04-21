require './404_finder.rb'
require 'anemone'
require 'uri'

pager = []

puts "What site would you like to index?"
$webSite = gets.chomp

$webSite.strip()

$webSite = "http://www.#{$webSite}.com" #fix in future

puts "What depth do you want to set this crawler to?"
depth = gets.chomp

$setDepth = depth.to_i

startTime = Time.now
  	puts "Test started at " + startTime.to_s #Start time


Anemone.crawl($webSite , :depth_limit => $setDepth, :obey_robots_txt => true, :threads => 8) do |anemone|
  anemone.on_every_page do |page|
  	puts page.url
pager.push(page.url)
end
end

puts "Test completed at #{Time.now}"
totalTime = Time.now - startTime
if totalTime <= 60
	puts "#{totalTime} seconds elapsed for indexing."
else
puts "Total time elapsed for indexing: #{totalTime.to_i/60} minutes."
end

puts "#{pager.length.to_s} pages indexed."

pager.uniq #eliminates duplicates

urlSet = pager.join(' ')
fname = 'urlFiles.txt'
filer = File.open(fname, 'w')
filer.puts urlSet
filer.close

puts "Would you like to check indexed pages for response codes and broken links?"
answer = gets.chomp

case answer
when "yes", "Yes", "YES", "y", "Y"
	BrokenLinkChecker.new
when "No", "no", "NO", "n", "N"
	puts "Program complete."
	abort()
else
	puts "Please enter yes or no"
end
