wikis=`grep -v -E "\|(closed|private)(\||$)" /usr/share/nginx/.orain.org/w/all.dblist | cut -d '|' -f 1`
date=`date +%Y%m%d`

while read wiki
do
	filename=$wiki-$date-pages-meta-history.xml
	php dumpBackup.php --wiki $wiki --full > ~/dumps/$filename
	7z a ~/dumps_7z/$filename.7z ~/dumps/$filename
done <<< $wikis

export AWS_ACCESS_KEY_ID="{{AWS_DUMPS_ACCESS_KEY_ID}}"
export AWS_SECRET_ACCESS_KEY="{{AWS_DUMPS_SECRET_ACCESS_KEY}}"
s3cmd sync ~/dumps_7z {{dumps_path}}
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

