cp $1 $1.bak
iconv -f MSCP949 -t UTF8 $1.bak -o $1

