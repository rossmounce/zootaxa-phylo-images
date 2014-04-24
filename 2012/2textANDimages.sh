#!/bin/bash
# Usage: attempt to make a plaintext conversion copy of all PDFs in all subfolders (maxdepth 1 folder down) of the working directory

# Turning on the nullglob shell option
shopt -s nullglob

# Loop through pwd cd'ing into each directory then pdftotext all PDFs within each subdirectory
  for f in *.pdf
	do
	echo "started on $f"
	STEM=$(echo $f | awk -F. '{ print $f }')
	echo "pdftotext $f"
	pdftotext "$f"
	echo "pdfimages $f"
        pdfimages -j "$f" ${STEM%%.*}
	echo "find and delete small files $f"
	find . -maxdepth 1 -type f -size -23k -regex ".*\(ppm\|jpg\|pbm\)$" -exec rm -rf {} \;
	grep 'FIGURE [0-9]' *.txt | sed 's/[^[:alnum:][:punct:][:blank:]]*//g' > captions${STEM%%.*}.out
	mkdir $STEM.folder
	#convert ppm's and pbm's to png's & jpg's
	find . -maxdepth 1 -type f -name '*.pbm' | cut -c 3- > pbms.zzz
	find . -maxdepth 1 -type f -name '*.ppm' | cut -c 3- > ppms.zzz
	for img in $(cat ppms.zzz) 
		do convert $img $img.png
	done
	for nimg in $(cat pbms.zzz) 
		do convert -negate $nimg $nimg.png
	done
	rm *.ppm
	rm *.pbm
	find . -maxdepth 1 -type f -name '*.txt' -exec mv "{}"  ./$STEM.folder \; 
	find . -maxdepth 1 -type f -name '*.jpg' -exec mv "{}"  ./$STEM.folder \;
	find . -maxdepth 1 -type f -name '*.png' -exec mv "{}"  ./$STEM.folder \;
	find . -maxdepth 1 -type f -name '*.ref' -exec mv "{}"  ./$STEM.folder \;
	find . -maxdepth 1 -type f -name '*.doi' -exec mv "{}"  ./$STEM.folder \;
	find . -maxdepth 1 -type f -name '*.out' -exec mv "{}"  ./$STEM.folder \;
	done
