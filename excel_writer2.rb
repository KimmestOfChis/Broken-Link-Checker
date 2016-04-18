require 'spreadsheet'

options = [1, 2, 3 , 4, 5, 6]
requirements = [7, 8, 8, 10, 11, 12]
specials = [13, 14, 15, 16, 17, 18]
inners = ['t', 'u', 'v', 'w', 'x', 'y']
letters = ['a', 'b', 'c', 'd','e','f']

zipMe = options.zip(requirements, specials, inners)
puts zipMe.to_s
hash = Hash[letters.zip(zipMe)]
puts hash

book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet :name => 'test'

hash.each do |name, array|
	sheet1.row(0).push name + "Dog"
	sheet1.row(1).push array[0]
	sheet1.row(2).push array[1]
	sheet1.row(3).push array[2]
	sheet1.row(4).push array[3]
end

book.write '/Users/matthewjohnson/Documents/projects/404projects/test2.xls'