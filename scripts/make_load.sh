#!/bin/bash
DIR="$( cd -P "$( dirname "$0" )" && pwd )"
DIR="$( cd -P $DIR/../curriculos && pwd )"

echo -e 'USE PROJETO1;\n' > $DIR/../populate.sql

max=24
for i in `seq 1 $max`; do
  FOLDER=$DIR/filtered/curriculo$i/load_files
  rm -rf $FOLDER
  mkdir $FOLDER
  for FILE in $( ls $DIR/filtered/curriculo$i/*.csv ); do
    FILENAME="$( basename "$FILE" .csv )"
    if [[ "$FILENAME" == "INTEGRANTE_DO_PROJETO" || "$FILENAME" == "FINANCIADOR_DO_PROJETO" ]]; then
        echo '' >> $FOLDER/tmp-table.sql
        sed -e "s#file_name#$FILE#g;" $DIR/../scripts/templates/$FILENAME.sql >> $FOLDER/tmp-table.sql
    elif [[ "$FILENAME" == "DOCENTE" ]]; then
      sed -e "s#file_name#$FILE#g; s#id_docente#$i#g;"    $DIR/../scripts/templates/$FILENAME.sql > $FOLDER/tmp.sql
      cat $FOLDER/curriculo$i.sql >> $FOLDER/tmp.sql
      mv $FOLDER/tmp.sql $FOLDER/curriculo$i.sql
    else
      echo -e '' >> $FOLDER/curriculo$i.sql
      sed -e "s#file_name#$FILE#g; s#id_docente#$i#g;"    $DIR/../scripts/templates/$FILENAME.sql >> $FOLDER/curriculo$i.sql
    fi
  done
  if [[ -f $FOLDER/curriculo$i.sql ]]; then
    cat $FOLDER/curriculo$i.sql >> $DIR/../populate.sql
    echo '' >> $DIR/../populate.sql
  fi
  if [[ -f $FOLDER/tmp-table.sql ]]; then
    cat $FOLDER/tmp-table.sql >> $DIR/../populate-proj.sql
    echo '' >> $DIR/../populate-proj.sql

  fi
  rm -rf  $FOLDER
done
cat $DIR/../populate-proj.sql >> $DIR/../populate.sql
cat $DIR/../scripts/templates/INSERT_SEX.sql >> $DIR/../populate.sql
rm $DIR/../populate-proj.sql
mv $DIR/../populate.sql $DIR/../populate_bd.sql

exit 0
