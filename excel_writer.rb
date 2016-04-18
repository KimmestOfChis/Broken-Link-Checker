require 'spreadsheet'

book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet :name => 'test'


sheet1.each do |row|
	dog = "dog"
	sheet1.row(0).push dog
end
book.write '/Users/matthewjohnson/Documents/projects/404projects/test.xls'