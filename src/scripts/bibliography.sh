#!/bin/bash

# bibliography -> vergleich in thisdoc.adoc, inhalt.adoc und anhaenge.adoc von referenzen mit bibliography.adoc -> individuelles bibliography.adoc

allBibRefs=($(gawk 'match($0, /\[\[\[(.+)\]\]\]/, m) { print m[1]}' common/bibliography.adoc))

findRefs() {
    for ref in $@
    do
        cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | gawk -v foundref=$ref 'match($0, /<<([a-zA-Z0-9]+)>>/, m) && m[1] == foundref { print m[1]; }' RS=" " | sort -u
    done
}

buildDocumentBibliography() {
    refs=($@)
    refsSize=${#refs[@]}

    if [ $refsSize -gt 0 ]
    then
        echo -e "[bibliography]\n== Literaturverweise" > $dir/bibliography.adoc

        for ref in $@
        do
          gawk -v foundref=$ref 'match($1, /\[\[\[(.+)\]\]\]/, m) && m[1] == foundref { print $0 }' RS='' FS='\n' common/bibliography.adoc | tee -a $dir/bibliography.adoc
        done
    else
        touch $dir/bibliography.adoc
    fi
}

for dir in 19*/
do
    bibRefs=$(findRefs ${allBibRefs[@]})
    buildDocumentBibliography ${bibRefs[@]}
done
