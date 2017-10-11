require 'rmagick'
include Magick

#cat = ImageList.new("chat1.jpg")
#cat.minify!
#cat.write("rslt.jpg")

img = ImageList.new
img.read("chat1.jpg")
img.read("chat2.jpg")
img.read("chat3.jpg")
img.read("chat4.jpg")


cpy = ImageList.new
page = Rectangle.new(0, 0, 0, 0)
4.times do |i|
	cpy << img.scale(110, 100)
	page.x = i * cpy.columns
	page.y = 0
	cpy.page = page
	(img.scene += 1) rescue img.scene = 0
end

momo = cpy.mosaic
#momo = cpy.montage {
#	#self.compose = UndefinedCompositeOp
#	self.frame = "200x200+0+0"
#	self.border_width = 0
#}
momo.write("rslt.jpg")
