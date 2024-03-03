#!/bin/bash

LOGDIR=$1
cd $LOGDIR
FILECNT=`ls esxtop-all-*.csv | wc -l`

### function log time
function log_time_conv () {
while read line
do
  VAL=$(echo $line | cut -d, -f 2-)
  TIME=$(echo $line | cut -d, -f 1 | sed -e 's/"//g')
  if [ "$TIME" = '(PDH-CSV 4.0) (UTC)(0)' ]; then
    TIME=JST
  else
    TIME=`date "+%H:%M:%S" -d "$TIME UTC"`
  fi
  echo \"$TIME\",$VAL
done
}

### esxtop util
echo " esxtop all to esxtop-util.csv"
for i in `seq 1 $FILECNT`
do
  head -1 esxtop-all-$i.csv | sed 's/,/\n/g' > esxtop-colum-$i.txt
  COL=`cat -n esxtop-colum-$i.txt |
       grep 'Physical Cpu(.*)\\\% Util Time' |
       awk '{printf "\$"$1"\",\""}'| sed 's/","$//' | sed 's/^/$1","/g'`
  if [[ $i = 1 ]] ;then
    awk -F"," "{print $COL}" esxtop-all-$i.csv |
    log_time_conv > esxtop-util.csv
  else
    awk -F"," "NR>1{print $COL}" esxtop-all-$i.csv |
    log_time_conv >> esxtop-util.csv
  fi
done

rm esxtop-colum-*.txt
