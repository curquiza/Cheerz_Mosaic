# Cheerz_Mosaic

## Description ##

A ruby script in command-line to create a mosaic based on the images passed in argument

Input : one JSON file with
 - 'filesize' : the size in Ko of the mosaic
 - 'hight' : hight of the mosaic
 - 'width' : width of the mosaic
 - 'photos' : a hash array of photos to put in the mosaic.
		- 'src' : URL address
		- 'pos_x' : position in the mosaic (columns)
		- 'pos_y' : position in the mosaic (rows)
		- 'hight' : hight of the image of the mosaic size in %
		- 'width' : width of the image of the mosaic size in %

Output : one JPG file

## How to use ##

```bash
bundle install
ruby mosaic.rb inputs/[file.json]
```

To run all inputs :
```bash
sh run_tests.sh
```
