#!/bin/sh

DIR=/vmfs/volumes/datastore1/esxtop-utils
CNT=`echo $(($1/30+1))`

echo
echo " esxtop start 2sec x 30 x $CNT"
echo

for i in `seq $CNT`
do
  esxtop -b -d 2 -n 30 -a > $DIR/esxtop-all-$i.csv
done

head -1 esxtop-all-1.csv | sed 's/,/\n/g' > esxtop-colum.txt
echo " esxtop finish 2sec x 30 x $CNT"
echo
exit
