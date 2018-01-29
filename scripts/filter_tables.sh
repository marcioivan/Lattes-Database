#!/bin/bash
DIR="$( cd -P "$( dirname "$0" )" && pwd )"/../curriculos
cp tables.txt tmp.txt
FILENAME=$(head -n 1 tmp.txt)
vi -c ':1d' -c ':wq' tmp.txt > /dev/null 2>&1
while [[ "$FILENAME" != "EOF" ]]; do
  for FOLDER in $( cd -P $DIR/original && ls -d c* ); do
    if [[ ! -d $DIR/filtered/$FOLDER ]]; then
      mkdir -p $DIR/filtered/$FOLDER
    fi
    if [[ -f $DIR/original/$FOLDER/$FILENAME ]]; then
      cp $DIR/original/$FOLDER/$FILENAME $DIR/filtered/$FOLDER/$FILENAME
    fi
  done
  FILENAME=$(head -n 1 tmp.txt)
  vi -c ':1d' -c ':wq' tmp.txt > /dev/null 2>&1
done
rm -rf tmp.txt

exit 0
