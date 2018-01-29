#!/bin/bash

DIR="$( cd -P "$( dirname "$0" )" && pwd )"
cd scripts

echo -e "Selecting correct tables...\n"
./filter_tables.sh
echo -e "Joining some tables...\n"
./join_tables.sh
echo -e "Fixing some names...\n"
./fix_names.sh
echo -e "Changing some rows...\n"
./filter_rows.sh
echo -e "Writing SQL file...\n"
./make_load.sh

if [[ $? -eq 0 ]]; then
  echo -e "All done!!\n"
  exit 0
else
  echo -e "Error!!\n"
  exit 1
fi
