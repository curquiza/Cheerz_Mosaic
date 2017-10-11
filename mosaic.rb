require 'json'
require 'rmagick'
include Magick

def is_sorted(a, b)
	if (a[pos_y] == b[pos_y])
		if (a[pos_x] < b[pos_x])
			return 1
		else
			return 0
		end
	elsif (a[pos_y] < b[pos_y])
		return 1
	else
		return 0
	end
end


# Get the data from json file
file = File.read('inputs/test.json')
data = JSON.parse(file)
photos = data['photos']

# Modify data of each photo
photos.each do |elem|
	elem['hight'] = data['hight'] * (elem['hight'].to_f / 100)
	elem['width'] = data['width'] * (elem['width'].to_f / 100)
end

# Sort the array 'photos'
photos = photos.sort { |a, b| a[pos_y, pos_x] <=> b[pos_y, pos_x] }

puts photos

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

