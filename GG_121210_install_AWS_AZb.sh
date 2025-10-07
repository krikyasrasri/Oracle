#!/bin/sh
#################################################################################################################
#### Author/Modifier  : Jaspreet Singh
#### Date   :Dec 8 -2017
#### Deploy GG 12.1.2.1.0 software
##################################################################################################################
export OGG_BASE=/u01/app/
export OGG_HOME=/u01/app/ogg/
NOW=$(date +"%m-%d-%Y")
TYPE=$1

mkdir -p $OGG_HOME
aws s3 cp s3://obill-gg-software/binaries/ogg_12.1.tar /u01/app 
#wget -P $OGG_BASE/  https://s3-us-west-2.amazonaws.com/obill-gg-software/binaries/ogg_12.1.tar
cd $OGG_BASE/
tar -xvf $OGG_BASE/ogg_12.1.tar
cd $OGG_HOME
#./ggsci
#exit
#exit
#echo obey /u01/app/obey_cmds.txt | $OGG/ggsci

#exit
#exit

#wget -P $OGG_HOME/dirprm  https://s3-us-west-2.amazonaws.com/obill-gg-software/e1awsweb.prm
#wget -P $OGG_HOME/dirprm  https://s3-us-west-2.amazonaws.com/obill-gg-software/mgr.prm
#wget -P $OGG_HOME/dirprm https://s3-us-west-2.amazonaws.com/obill-gg-software/p1awsweb.prm
#wget -P $OGG_HOME/dirprm https://s3-us-west-2.amazonaws.com/obill-gg-software/r1awsweb.prm
#wget -P $OGG_HOME/ https://s3-us-west-2.amazonaws.com/obill-gg-software/ENCKEYS
#aws s3 cp s3://obill-gg-software/binaries/gg_add_a.sh /u01/app/
#aws s3 cp s3://obill-gg-software/binaries/obey_add_a.txt /u01/app/
#aws s3 cp s3://obill-gg-software/binaries/gg_add_b.sh /u01/app/
#aws s3 cp s3://obill-gg-software/binaries/obey_add_a.txt /u01/app/

#wget -P $OGG_BASE/ https://s3-us-west-2.amazonaws.com/obill-gg-software/obey_mgr_start.txt
#wget -P $OGG_BASE/ https://s3-us-west-2.amazonaws.com/obill-gg-software/obey_addextract.txt
#wget -P $OGG_BASE/ https://s3-us-west-2.amazonaws.com/obill-gg-software/obey_addpump.txt
#wget -P /u01/app/ https://s3-us-west-2.amazonaws.com/obill-gg-software/obey_addreplicat.txt
echo obey $OGG_HOME/obey_mgr_start.txt | /u01/app/ogg/ggsci
#echo obey /u01/app/obey_addextract.txt | /u01/app/ogg/ggsci
#echo obey /u01/app/obey_addpump.txt | /u01/app/ogg/ggsci
#echo obey $OGG_BASE/obey_addreplicat.txt | /u01/app/ogg/ggsci
echo obey $OGG_HOME/obey_add_b.txt | /u01/app/ogg/ggsci
exit
exit

