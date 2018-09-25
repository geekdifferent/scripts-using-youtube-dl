#!/bin/bash
#This playlist is Nightly News.
PLAYLIST="https://www.youtube.com/playlist?list=PL0tDb4jw6kPyGy4AIjirldbeP6nxpWGKU"
BASE_URL="https://www.youtube.com/watch?v="
BASE_STRING="Nightly News Broadcast"

#Write your download directory.
#DOWN_DIR="/home/myhone/video"
DOWN_DIR=$HOME

TMP_DIR=$DOWN_DIR"/_tmp_nightly_news"
MAX_DW="3"

YOUTUBE_DL=`which youtube-dl`

OIFS="$IFS"
IFS=$'\n'

cd $DOWN_DIR
mkdir $TMP_DIR

mv *$BASE_STRING*.mp4 $TMP_DIR

for ID in `$YOUTUBE_DL --dateafter now-1week --match-title $BASE_STRING --max-downloads $MAX_DW $PLAYLIST --get-id `; do
    URL=$BASE_URL$ID
    FILE=`$YOUTUBE_DL --get-filename -o '%(title)s.%(ext)s' $URL`

    if [ -f "$TMP_DIR/$FILE" ]; then
        echo "File [$FILE] exists."
        mv $TMP_DIR/$FILE $TMP_DIR/..
    else
        echo "File [$FILE] does not exists."
        $YOUTUBE_DL -f 'best' -o $DOWN_DIR/'%(title)s.%(ext)s' $URL
    fi
done

rm -drf $TMP_DIR
IFS="$OIFS"

exit 1
