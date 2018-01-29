#!/bin/bash

DIR="$( cd -P "$( dirname "$0" )" && pwd )"/../curriculos/filtered

for FOLDER in $( ls -d $DIR/c* ); do
  if [[ ! -d $FOLDER/load_files ]]; then
    mkdir $FOLDER/load_files
  fi
  for FILE in $( ls -d $FOLDER/*.csv ); do
    vim -c ':set nobomb' -c ':wq' $FILE > /dev/null 2>&1
  done
  NAME="ORIENTACAO-EM-ANDAMENTO-DE-DOUTORADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DA-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv $FOLDER/DETALHAMENTO-DA-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DA-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DA-${NAME}.csv
  fi
  NAME="ORIENTACAO-EM-ANDAMENTO-DE-INICIACAO-CIENTIFICA"
  if [[ -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DA-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv $FOLDER/DETALHAMENTO-DA-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DA-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DA-${NAME}.csv
  fi
  NAME="ORIENTACAO-EM-ANDAMENTO-DE-MESTRADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DA-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv $FOLDER/DETALHAMENTO-DA-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DA-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DA-${NAME}.csv
  fi
  NAME="ORIENTACAO-EM-ANDAMENTO-DE-POS-DOUTORADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DA-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv $FOLDER/DETALHAMENTO-DA-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DA-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DA-${NAME}.csv
  fi
  NAME="PARTICIPACAO-EM-BANCA-DE-DOUTORADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DA-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv $FOLDER/DETALHAMENTO-DA-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DA-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DA-${NAME}.csv
  fi
  NAME="PARTICIPACAO-EM-BANCA-DE-MESTRADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DA-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DA-${NAME}.csv $FOLDER/DETALHAMENTO-DA-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DA-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DA-${NAME}.csv
  fi
  NAME="ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DE-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DE-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DE-${NAME}.csv $FOLDER/DETALHAMENTO-DE-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DE-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DE-${NAME}.csv
  fi
  NAME="ORIENTACOES-CONCLUIDAS-PARA-MESTRADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DE-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DE-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DE-${NAME}.csv $FOLDER/DETALHAMENTO-DE-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DE-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DE-${NAME}.csv
  fi
  NAME="ORIENTACOES-CONCLUIDAS-PARA-POS-DOUTORADO"
  if [[ -f $FOLDER/DADOS-BASICOS-DE-${NAME}.csv && -f $FOLDER/DETALHAMENTO-DE-${NAME}.csv ]]; then
    mlr --csv join -u -j ${NAME}_Id -f $FOLDER/DADOS-BASICOS-DE-${NAME}.csv $FOLDER/DETALHAMENTO-DE-${NAME}.csv > $FOLDER/${NAME}.csv

    rm $FOLDER/DADOS-BASICOS-DE-${NAME}.csv
    rm $FOLDER/DETALHAMENTO-DE-${NAME}.csv
  fi
  if [[ -f $FOLDER/DISCIPLINA.csv && -f $FOLDER/ENSINO.csv ]]; then
    mlr --csv join -u -j ENSINO_Id -f $FOLDER/DISCIPLINA.csv $FOLDER/ENSINO.csv > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/DISCIPLINA.csv

    mlr --csv cut -o -f ATUACAO-PROFISSIONAL_Id,NOME-INSTITUICAO $FOLDER/ATUACAO-PROFISSIONAL.csv > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/ATUACAO-PROFISSIONAL.csv

    mlr --csv join -u -j ATUACAO-PROFISSIONAL_Id -f $FOLDER/ATUACAO-PROFISSIONAL.csv $FOLDER/ATIVIDADES-DE-ENSINO.csv > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/ATIVIDADES-DE-ENSINO.csv

    mlr --csv join -u -j ATIVIDADES-DE-ENSINO_Id -f $FOLDER/DISCIPLINA.csv $FOLDER/ATIVIDADES-DE-ENSINO.csv > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/DISCIPLINA.csv

    rm $FOLDER/ATIVIDADES-DE-ENSINO.csv
    rm $FOLDER/ENSINO.csv
  fi
  COLUMS="NOME-DO-PROJETO,PROJETO-DE-PESQUISA_Id"
  if [[ -f $FOLDER/PROJETO-DE-PESQUISA.csv ]]; then
    mlr --csv cut -o -f $COLUMS $FOLDER/PROJETO-DE-PESQUISA.csv > $FOLDER/proj-tmp.csv
  fi
  if [[ -f $FOLDER/INTEGRANTES-DO-PROJETO.csv ]]; then
    csvjoin -d ',' -c EQUIPE-DO-PROJETO_Id $FOLDER/INTEGRANTES-DO-PROJETO.csv $FOLDER/EQUIPE-DO-PROJETO.csv  > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/INTEGRANTES-DO-PROJETO.csv
    csvjoin -d ',' -c PROJETO-DE-PESQUISA_Id $FOLDER/INTEGRANTES-DO-PROJETO.csv $FOLDER/proj-tmp.csv  > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/INTEGRANTES-DO-PROJETO.csv

    rm $FOLDER/EQUIPE-DO-PROJETO.csv
  fi
  if [[ -f $FOLDER/FINANCIADOR-DO-PROJETO.csv ]]; then
    csvjoin -d ',' -c FINANCIADORES-DO-PROJETO_Id $FOLDER/FINANCIADORES-DO-PROJETO.csv $FOLDER/FINANCIADOR-DO-PROJETO.csv   > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/FINANCIADOR-DO-PROJETO.csv
    csvjoin -d ',' -c PROJETO-DE-PESQUISA_Id $FOLDER/proj-tmp.csv $FOLDER/FINANCIADOR-DO-PROJETO.csv   > $FOLDER/tmp.csv
    mv $FOLDER/tmp.csv $FOLDER/FINANCIADOR-DO-PROJETO.csv

    rm $FOLDER/FINANCIADORES-DO-PROJETO.csv
  fi
  if [[ -f $FOLDER/PROJETO-DE-PESQUISA.csv ]]; then
    rm $FOLDER/proj-tmp.csv
  fi

done
exit 0
