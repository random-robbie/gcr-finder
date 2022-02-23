#!/bin/bash
#

check_target () {
	if $(curl -i -s -k -X 'POST' -H 'Content-Type: application/json' --data-binary "['$1',null,null,[11]]" https://console.cloud.google.com/m/gcr/entities/list | grep -qi "gcr.ListEntities"); then
		echo "https://gcr.io/$1"
	fi
}
export -f check_target
>/tmp/targets.tmp
# Scrape targets to get more targets
echo "Generating List"
rm -rf /tmp/targets.txt
for line in `cat list.txt`; do
echo "$1-$line" >> /tmp/targets.txt
done
wait
echo "Testing targets..."
parallel -a /tmp/targets.txt -j 25 --bar check_target | tee found.txt
if [[ $(cat found.txt) == "" ]]; then
	echo "No results found."
else
	echo "Done."
fi
