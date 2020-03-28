#!/bin/sh

src=$1
dst=$2
mkdir -p $dst
searchx()
{
  src=$1
  for FILE in $src/*
  do
    if [[ -d "$FILE" ]]; then
      searchx $FILE
    else
      if [[ ${FILE,,} = *."jpg" ||  ${FILE,,} = *."jpeg" || ${FILE,,} = *."png" ]]; then
        date=$(stat -c '%y' $FILE | cut -d "-" -f1)
        mkdir -p $dst/$date/photos
        cp -n $FILE $dst/$date/photos

      fi
      if [[ ${FILE,,} = *."mov" ||  ${FILE,,} = *."avi" || ${FILE,,} = *."3gp" \
            || ${FILE,,} = *."mpeg" || ${FILE,,} = *."mkv" || ${FILE,,} = *."wmv" \
            || ${FILE,,} = *."mp4" ]]; then

        date=$(stat -c '%y' $FILE | cut -d "-" -f1)
        mkdir -p $dst/$date/videos
        cp -n $FILE $dst/$date/videos
      fi
    fi
  done
}
convertx()
{
  dst=$1
  for FILE in $dst/*
  do
    if [[ -d "$FILE" ]]; then
      convertx $FILE
    else
      if [[ ${FILE,,} = *."jpg" ||  ${FILE,,} = *."jpeg" || ${FILE,,} = *."png" ]]; then
        checkwidth=$(identify -format "%wx%h" $FILE | cut -d "x" -f1)
        if [[ $checkwidth -ge 1024 ]]; then
          convert $FILE -resize 1024x100000\> $FILE
        fi
      fi
    fi
  done
}
searchx $src
convertx $dst
