#!/bin/bash

FILES=inputs/*.json

for f in $FILES
do
	echo -n "$f ... "
	ruby mosaic.rb $f
	echo "done"
done
