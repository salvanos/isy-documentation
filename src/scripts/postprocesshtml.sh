#!/bin/bash

allFiles=($(ls *.html))
basenames=($(basename -s .html *))

replaceLinks() {
    echo "=> Replacing reference $1"
    sed -i -r "s/<a href=\"#($1)\">/<a href=\"\1.html\">/" $2
}

removeFromBibliography() {
    echo "=> Removing $1 from bibliography"
    sed -i -z "s/<li>\n<p><a id=\"$1\"><\/a>\[$1\]<br>\n[^\n]\+\n[^\n]\+\n<\/li>\n//g" $2
}

for htmlFile in ${allFiles[@]}
do
    echo Post-processing $htmlFile

    for basename in ${basenames[@]}
    do
        replaceLinks $basename $htmlFile
        removeFromBibliography $basename $htmlFile
    done
done
