require 'json'
require 'rmagick'
include Magick

# Get the data from json file
if (ARGV.empty? == true)
	exit
end
index = ARGV[0].rindex('/')
if (index == nil)
	index = 0
else
	index += 1
end
filename = ARGV[0][index..-1]
file = File.read(ARGV[0])
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
	puts "width attendue = #{elem['width']}"
	puts "hight attendue = #{elem['hight']}"
	puts '----'
	puts "col debut = #{img.columns}"
	puts "row debut = #{img.rows}"
	puts '----'

	# Resize
	fact = 0.2
	if (img.columns <= elem['width'] || img.rows <= elem['hight'])
		while (img.columns <= elem['width'] || img.rows <= elem['hight']) do
			img.scale!(1 + fact)
			puts "col loop = #{img.columns}"
			puts "row loop = #{img.rows}"
			puts '----'
		end
	else
		while (img.columns * (1 - fact) >= elem['width'] && img.rows * (1 - fact) >= elem['hight']) do
			img.scale!(1 - fact)
			puts "col loop = #{img.columns}"
			puts "row loop = #{img.rows}"
			puts '----'
		end
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
#mosaic.write("momo.jpg")

# Contruct the image resulting
rslt = Image.new(data['width'], data['hight']) {
	self.background_color = "black"
	self.format = 'JPG'
}
rslt.composite!(mosaic, 0, 0, OverCompositeOp)

# Calculate the quality
quality = 1
size = data['filesize'] * 1000
while (quality < 100 && rslt.to_blob{ self.quality = quality }.bytesize < size) do
	quality += 1
end

# Write the result
puts "Quality = #{quality}"
puts "filesize asked = #{size}"
rslt.write("outputs/rslt_" + filename[0..-6] + ".jpg") { self.quality = quality }
puts "filesize = #{rslt.filesize}"
