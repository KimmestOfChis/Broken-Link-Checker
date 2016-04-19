require 'anemone'



puts "What site would you like to search?"
$webSite = gets.chomp

$webSite = "http://www.#{$webSite}"


puts "What depth do you want to set this crawler to?"
depth = gets.chomp

$setDepth = depth.to_i

startTime = Time.now
  	puts "Test started at " + startTime.to_s #Start time


Anemone.crawl($webSite , :depth_limit => $setDepth, :obey_robots_txt => true, :threads => 4) do |anemone|
  anemone.on_every_page do |page|
  	puts page.url
pager.push(page.url)
end
end