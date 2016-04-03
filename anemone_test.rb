require 'anemone'
require 'uri'

pager = []

Anemone.crawl("http://www.trektoday.com/" , :depth_limit => 10) do |anemone|
  anemone.on_every_page do |page|
  	puts page.url
pager.push(page.url)
end
end


urlSet = pager.join(' ')
fname = 'urlFiles.txt'
filer = File.open(fname, 'w')
filer.puts urlSet
filer.close
