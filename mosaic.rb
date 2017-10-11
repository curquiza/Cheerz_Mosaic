require 'rmagick'
include Magick

#cat = ImageList.new("chat1.jpg")
#cat.minify!
#cat.write("rslt.jpg")

rslt = Image.new(2000, 800)

img = ImageList.new
img.read("chat1.jpg")
img.read("chat2.jpg")
img.read("chat3.jpg")
img.read("chat4.jpg")

#cpy = ImageList.new
#page = Rectangle.new(0, 0, 0, 0)
#4.times do |i|
#	cpy << img.scale(110, 100)
#	page.x = i * cpy.columns
#	page.y = 0
#	cpy.page = page
#	(img.scene += 1) rescue img.scene = 0
#end

col = 0
row = 0
page = Rectangle.new(0, 0, 0, 0)
4.times do
	page.x = col
	col += img.columns
	puts "col = #{col}"
	puts "page.x = #{page.x}"
	page.y = 0
	img.page = page
	(img.scene += 1) rescue img.scene = 0
end

momo = img.mosaic

#momo = img.montage {
#	self.tile = "2x2"
#	self.geometry = "200x200+0+0"
#}

rslt.composite!(momo, 0, 0, OverCompositeOp)

rslt.write("rslt.jpg")

