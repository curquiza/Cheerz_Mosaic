require 'json'
require 'rmagick'
include Magick

def calc_quality(filesize, rslt)
	quality = 1
	size = filesize * 1000
	while (quality < 100 && rslt.to_blob{ self.quality = quality }.bytesize < size) do
		quality += 1
	end
	quality
end

def resize_img(fact, img, elem_photos)
	if (img.columns <= elem_photos['width'] || img.rows <= elem_photos['hight'])
		while (img.columns <= elem_photos['width'] || img.rows <= elem_photos['hight']) do
			img.scale!(1 + fact)
		end
	else
		while (img.columns * (1 - fact) >= elem_photos['width'] && img.rows * (1 - fact) >= elem_photos['hight']) do
			img.scale!(1 - fact)
		end
	end
	img.crop!(CenterGravity, elem_photos['width'], elem_photos['hight'])
	img
end

# Get the data from json file
exit if ARGV.empty?
filename = File.basename(ARGV[0])
file = File.read(ARGV[0]) rescue exit
data = JSON.parse(file)
photos = data['photos']

# Modify data of each photo
photos.each do |elem|
	elem['hight'] = data['hight'] * (elem['hight'].to_f / 100)
	elem['width'] = data['width'] * (elem['width'].to_f / 100)
end

# Sort the array 'photos'
photos = photos.sort_by{ |elem| [elem['pos_y'], elem['pos_x']] }

# Get and resize the photo in ImageList
img = ImageList.new
photos.each do |elem|
	img.read(elem['src'])
	img.background_color = 'black'
	img = resize_img(0.2, img, elem)
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
	x = photos.count { |elem| elem['pos_y'] == j }
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

# Contruct the image resulting
rslt = Image.new(data['width'], data['hight']) {
	self.background_color = "black"
	self.format = 'JPG'
}
rslt.composite!(mosaic, 0, 0, OverCompositeOp)

# Write the result
rslt.write("outputs/rslt_" + filename[0..-6] + ".jpg") { self.quality = calc_quality(data['filesize'], rslt) } \
rescue rslt.write("rslt_" + filename[0..-6] + ".jpg") { self.quality = calc_quality(data['filesize'], rslt) }
