#!/bin/bash

FILES=inputs/*.json

for f in $FILES
do
	printf "$f ... "
	ruby mosaic.rb $f
	echo "done"
done
