#!/bin/bash
DIR="$( cd -P "$( dirname "$0" )" && pwd )"/../curriculos

cp old_filename.txt tmp
cp new_filename.txt new_tmp

FILENAME=$(head -n 1 tmp)
vi -c ':1d' -c ':wq' tmp > /dev/null 2>&1

NEW_FILENAME=$(head -n 1 new_tmp)
vi -c ':1d' -c ':wq' new_tmp > /dev/null 2>&1

while [[ "$FILENAME" != "EOF" ]]; do
  for FOLDER in $( ls -d $DIR/filtered/c*  ); do
    FILE="$( basename "$DIR/templates/$FILENAME" .sql)"
    NEW_FILE="$( basename "$DIR/templates/$NEW_FILENAME" .sql)"
    if [[ ! -d $FOLDER/load_files ]]; then
      mkdir $FOLDER/load_files
    fi
    if [[ -f $FOLDER/$FILE.csv ]]; then
      head -n 1 $FOLDER/$FILE.csv > $FOLDER/load_files/tmp$FILE.csv
      vi -c ':1d' -c ':wq' $FOLDER/$FILE.csv > /dev/null 2>&1
      sed -i "s#-#_#g" $FOLDER/load_files/tmp$FILE.csv
      cat $FOLDER/$FILE.csv >> $FOLDER/load_files/tmp$FILE.csv
      rm $FOLDER/$FILE.csv
      mv $FOLDER/load_files/tmp$FILE.csv $FOLDER/$NEW_FILE.csv
    fi
  done
  FILENAME=$(head -n 1 tmp)
  vi -c ':1d' -c ':wq' tmp > /dev/null 2>&1
  NEW_FILENAME=$(head -n 1 new_tmp)
  vi -c ':1d' -c ':wq' new_tmp > /dev/null 2>&1
done
rm -rf tmp
rm -rf new_tmp

for FOLDER in $( ls -d $DIR/filtered/c*  ); do
  for FILE in $( ls $FOLDER/*.csv ); do
    sed -i -e 's#False#0#g; s#True#1#g;' $FILE
    sed -i -e  's#,,#,NULL,#g; s#,"",#,NULL,#g; s#,[[:blank:]]*$#,NULL#g;' $FILE
    sed -i -e 's#,""[[:blank:]]*$#,NULL#g;' $FILE
    vim -c ':set nobomb' -c ':wq' $FILE
    #sort -u myfile.csv -o myfile.csv
  done
done

exit 0

cp new_filename.txt tmp
FILENAME=$(head -n 1 tmp)
vi -c ':1d' -c ':wq' tmp > /dev/null 2>&1

while [[ $FILENAME.csv ]]; do
  TABLE="$( basename $FILENAME.csv .sql )"
  echo "LOAD DATA INFILE 'file_name' INTO TABLE $TABLE
    CHARACTER SET utf8
    FIELDS TERMINATED BY '\"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (col_name_or_user_var, col_name_or_user_var)
    SET   col_name={expr | DEFAULT},
          col_name={expr | DEFAULT}]; " > templates/$FILENAME.csv

  FILENAME=$(head -n 1 tmp)
  vi -c ':1d' -c ':wq' tmp > /dev/null 2>&1
done
rm -rf tmp

exit 0

for FOLDER in $( ls -d $DIR/filtered/c*  ); do
  for FILE in $( ls $FOLDER/*.csv ); do
    FILENAME="$( basename "$FILE" )"
    sed -i -e 's#,,#,NULL,#g; s#,"",#,NULL,#g; s#,$#,NULL#g; s#,""$#,NULL#g' $FILE
    #sort -u myfile.csv -o myfile.csv
    #csvim -c ':set nobomb' -c ':wq' $FILE
    #sed -i -e "s#False#0#g; s#True#1#g;" $FILE

  done
done

exit 0
