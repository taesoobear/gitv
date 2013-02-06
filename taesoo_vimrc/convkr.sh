cp $1 $1.bak
iconv -f EUCKR -t UTF8 $1.bak -o $1

