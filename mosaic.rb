require 'json'
require 'rmagick'
include Magick

# Get the data from json file
file = File.read('inputs/test.json')
data = JSON.parse(file)
photos = data['photos']
puts photos
puts '****************************'

# Modify data of each photo
photos.each do |elem|
	elem['hight'] = data['hight'] * (elem['hight'].to_f / 100)
	elem['width'] = data['width'] * (elem['width'].to_f / 100)
end

# Sort the array 'photos'
photos = photos.sort_by{ |elem| [elem['pos_y'], elem['pos_x']] }

puts photos
puts '****************************'

# Get the photo in ImageList
img = ImageList.new
photos.each do |elem|
	img.read(elem['src'])
	img.background_color = 'black'
	puts "elem['width'] = #{elem['width']}"
	puts "elem['hight'] = #{elem['hight']}"
	puts '----'
	puts "col debut = #{img.columns}"
	puts "row debut = #{img.rows}"
	puts '----'

	# Resize
	#size = 1.2
	while (img.columns <= elem['width'] || img.rows <= elem['hight']) do
		img.scale!(1.2)
		#size += 0.2
		puts "col loop = #{img.columns}"
		puts "row loop = #{img.rows}"
		puts '----'
	end
	img.crop!(CenterGravity, elem['width'], elem['hight'])
	puts "col finale = #{img.columns}"
	puts "row finale = #{img.rows}"
	puts '----'
	puts ''

end

# Construct the mosaic
col = 0
row = 0
page = Rectangle.new(0, 0, 0, 0)
img.scene = 0
y = photos.uniq { |elem| elem['pos_y'] }.length
y.times do |j|
	tmp_row = 0
	col = 0
	x = photos.count { |elem| elem['pos_y'] == j}
	x.times do
		page.x = col
		page.y = row
		img.page = page
		col += img.columns
		tmp_row = img.rows if (tmp_row < img.rows)
		(img.scene += 1) rescue img.scene = 0
	end
	row += tmp_row
end

mosaic = img.mosaic
mosaic.write("momo.jpg")

# Contruct the image resulting
rslt = Image.new(data['width'], data['hight']) {
	self.background_color = "black"
	self.format = 'JPG'
}
rslt.composite!(mosaic, 0, 0, OverCompositeOp)

# Calculate the quality
quality = 1
while (quality < 100 && rslt.to_blob{ self.quality = quality }.bytesize < size) do
	quality += 1
end

# Write the result
puts "\nQuality = #{quality}"
puts "\nfilesize = #{size}"
rslt.write("rslt.jpg") { self.quality = quality }
puts "filesize = #{rslt.filesize}"


#rslt = Image.new(2000, 2000) {
#	self.background_color = "black"
#	self.format = 'JPG'
#}
#
#img = ImageList.new
#img.read("http://www.zoomalia.com/cat_img/cat-2.jpg")
#img.background_color = "black"
#img.read("https://www.consoglobe.com/wp-content/uploads/2016/09/shutterstock_172105073-chaton-litieres-pour-chat.jpg")
#img.read("https://www.wanimo.com/veterinaire/images/articles/chat/question_du_mois-chat.jpg")
#img.read("https://www.royalcanin.fr/wp-content/uploads/chat-male-ou-femelle.jpg")
#img.read("http://www.animaniacs.fr/wp-content/uploads/2016/05/chat-noir.jpg")
#img.read("https://www.wanimo.com/veterinaire/images/articles/chat/chaton-diarrhee.jpg")
#
#
#x = 3
#y = 2
#
#col = 0
#row = 0
#page = Rectangle.new(0, 0, 0, 0)
#img.scene = 0
#y.times do
#	tmp_row = 0
#	col = 0
#	x.times do
#		page.x = col
#		page.y = row
#		img.page = page
#		col += img.columns
#		tmp_row = img.rows if (tmp_row < img.rows)
#		(img.scene += 1) rescue img.scene = 0
#	end
#	row += tmp_row
#end
#
#momo = img.mosaic
#rslt.composite!(momo, 0, 0, OverCompositeOp)
#
#blob = rslt.to_blob { self.quality = 1 }
#puts "blob.bytesize = #{blob.bytesize}"
#
#rslt.write("rslt.jpg") { self.quality = 1 }
#puts "filesize = #{rslt.filesize}"
