#!/bin/bash
# Author: Andrea Lazzarotto
# http://andrealazzarotto.com
# andrea.lazzarotto@gmail.com

# Slideshare Downloader
# This script takes a slideshare presentation URL as an argument and
# carves all the slides in flash format, then they are converted to
# and finally merged as a PDF

# License:
# Copyright 2010-2011 Andrea Lazzarotto
# This script is licensed under the Gnu General Public License v3.0.
# You can obtain a copy of this license here: http://www.gnu.org/licenses/gpl.html

# Usage:
# slideshare-downloader.sh URL [X-SIZE] [Y-SIZE]

#-----------------------------------------------
# Modify 3/20/2013 by kelviN
# Email  kowochen[at]gmail[dot]com 
#-----------------------------------------------
validate_input() {
    # Performs a very basic check to see if the url is in the correct form
    URL=`echo "$1" | cut -d "#" -f 1 | cut -d "/" -f 1-5`
    DOMAIN=`echo "$URL" | cut -d "/" -f 3`
    CORRECT='www.slideshare.net'
    if [[ "$DOMAIN" != "$CORRECT" ]];
        then
            echo "Provided URL is not valid. Need www subdomain"
            exit 1
    fi
    
    if echo -n "$2" | grep "^[0-9]*$">/dev/null
        then XSIZE=$2
        else
            XSIZE=1920
            echo "X-Size not defined or invalid... defaulting to 1920"
    fi

    if echo -n "$3" | grep "^[0-9]*$">/dev/null
        then YSIZE=$3
        else
            YSIZE=1440
            echo "Y-Size not defined or invalid... defaulting to 1440"
    fi
}

check_dependencies() {
    # Verifies if all binaries are present
    DEP="wget gsed seq swfrender convert"
    ERROR="0"
    for i in $DEP; do
        WHICH="`which $i`"
        if [[ "x$WHICH" == "x" ]];
            then
                echo "Error: $i not found."
                ERROR="1"
        fi
    done
    if [ "$ERROR" -eq "1" ];
        then
            echo "You need to install some packages."
            echo "Remember: this script requires Imagemagick and Swftools."
            exit 1
    fi
}

build_params() {
    # Gathers required information
    DOCSHORT=`echo "$1" | cut -d "/" -f 5`
    echo "Download of $DOCSHORT started."
    echo "Fetching information..."
    INFOPAGE=`wget -q -O - "$1"`
    DOCID=`echo "$INFOPAGE" | grep -o "doc=[a-z0-9-]\+"`
    if [[ "$DOCID" =~ ([a-z0-9-]+)$ ]]
    then
        DOCID=${BASH_REMATCH[0]}
    else
        echo $DOCID
        exit 1
    fi
    SLIDES=`echo "$INFOPAGE" | grep "totalSlides" | head -n 1 | gsed -s "s/.*totalSlides//g" | cut -d ":" -f 2 | cut -d "," -f 1`
    echo "DocId: $DOCID"
    echo "Slides: $SLIDES"
    echo "Size: $XSIZE x $YSIZE"
}

create_env() {
    # Finds a suitable name for the destination directory and creates it
    DIR=$DOCSHORT
    if [ -e "$DIR" ];
        then
            I="-1"
            OLD=$DIR
            while [ -e "$DIR" ]
            do
                I=$(( $I + 1 ))
                DIR="$OLD.$I"
            done
    fi
    mkdir "$DIR"
}

fetch_slides() {
    for i in $( seq 1 $SLIDES ); do
        echo "Downloading slide $i"
        wget "http://cdn.slidesharecdn.com/`echo $DOCID`-slide-`echo $i`.swf" -q -O "$DIR/slide-`echo $i`.swf"
    done
    echo "All slides downloaded."
}

convert_slides() {
    for i in $( seq 1 $SLIDES ); do
        echo "Converting slide $i"
        swfrender $DIR/slide-$i.swf -X $XSIZE -Y $YSIZE -o $DIR/slide-$i.png 2>/dev/null
    done
    echo "All slides converted."
}

build_pdf() {
    IMAGES=`ls $DIR/*.png | gsort -V`
    echo "Generating PDF..."
    convert $IMAGES $DIR/$DOCSHORT.pdf
    echo "The PDF has been generated."
    echo "Find your presentation in: \"`pwd`/$DIR/$DOCSHORT.pdf\""
}

clean() {
    rm -rf $DIR/slide-*.swf
    rm -rf $DIR/slide-*.png
}

validate_input $1 $2 $3
check_dependencies
build_params $URL
create_env
fetch_slides
convert_slides
build_pdf
clean
