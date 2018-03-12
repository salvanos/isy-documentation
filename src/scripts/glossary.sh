#!/bin/bash

IFS=$'\n'

# glossary -> [id="glossar-sjakfha"]

readGlossaryTerms() {
    gawk 'match($0, /\[id="(.+)",.+\]/, m) { print m[1] }' common/glossary.adoc
}

# suche in jeder Zeile nach spitzen Klammern (und glossar) und spitze klammer zu. Schreibe sie raus. Schmeiss doppelte weg.

findTerms() {
    for term in $@
    do
        cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | gawk -v foundref=$term 'match($0, /<<(.+)>>/, m) && m[1] == foundref { print m[1]; }' | sort -u
    done
}

buildDocumentGlossary() {
    terms=($@)
    termsSize=${#terms[@]}

    if [ $termsSize -gt 0 ]
    then
        echo -e "[glossary]\n== Glossar" > $dir/glossary.adoc

        for term in $@
        do
          gawk -v foundterm=$term 'match($1, /\[id="(.+)",.+\]/, m) && m[1] == foundterm { print $0 }' RS='' FS='\n' common/glossary.adoc | tee -a $dir/glossary.adoc
        done
    else
        touch $dir/glossary.adoc
    fi
}

# Hauptprogramm -> führt readGlossaryTerms() und dann findTerms() aus

allGlossaryTerms=$(readGlossaryTerms)

for dir in 19*/
do
    foundTerms=$(findTerms ${allGlossaryTerms[@]})
    buildDocumentGlossary ${foundTerms[@]}
done
