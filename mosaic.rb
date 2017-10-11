require 'rmagick'
include Magick

#cat = ImageList.new("chat1.jpg")
#cat.minify!
#cat.write("rslt.jpg")

rslt = Image.new(2000, 2000)

img = ImageList.new
img.read("chat1.jpg")
img.read("chat2.jpg")
img.read("chat3.jpg")
img.read("chat4.jpg")
img.read("http://www.animaniacs.fr/wp-content/uploads/2016/05/chat-noir.jpg")
img.read("https://www.wanimo.com/veterinaire/images/articles/chat/chaton-diarrhee.jpg")


x = 3
y = 2

col = 0
row = 0
page = Rectangle.new(0, 0, 0, 0)
img.scene = 0
y.times do
	tmp_row = 0
	col = 0
	x.times do
		puts img.base_filename
		page.x = col
		page.y = row
		img.page = page
		col += img.columns
		tmp_row = img.rows if (tmp_row < img.rows)
		(img.scene += 1) rescue img.scene = 0
	end
	row += tmp_row
end

momo = img.mosaic

rslt.composite!(momo, 0, 0, OverCompositeOp)

rslt.write("rslt.jpg")

