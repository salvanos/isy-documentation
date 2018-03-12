#!/bin/bash

# vergleich von id="table- und desc-table mit

buildListOfTables() {
    cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | egrep -q '\[id="(table-.+)",'

    if [ $? -eq 0 ]
    then
        echo -e "\n== Tabellenverzeichnis\n" > $dir/listoftables.adoc

        cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | gawk 'match($0, /\[id="(table-.+)",/, m) { print "<<" m[1] ">>" " {desc-" m[1] "}\n" }' | tee -a $dir/listoftables.adoc
    else
        touch $dir/listoftables.adoc
    fi
}

buildListOfFigures() {
    cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | egrep -q '\[id="(image-.+)",'

    if [ $? -eq 0 ]
    then
        echo -e "\n== Abbildungsverzeichnis\n" > $dir/listoffigures.adoc

        cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | gawk 'match($0, /\[id="(image-.+)",/, m) { print "<<" m[1] ">>" " {desc-" m[1] "}\n" }' | tee -a $dir/listoffigures.adoc
    else
        touch $dir/listoffigures.adoc
    fi
}

buildListOfListings() {
    cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | egrep -q '\[id="(listing-.+)",'

    if [ $? -eq 0 ]
    then
        echo -e "\n== Listenverzeichnis\n" > $dir/listoflistings.adoc

        cat $dir/thisdoc.adoc $dir/inhalt.adoc $dir/anhaenge.adoc | gawk 'match($0, /\[id="(listing-.+)",/, m) { print "<<" m[1] ">>" " {desc-" m[1] "}\n" }' | tee -a $dir/listoflistings.adoc
      else
          touch $dir/listoflistings.adoc
      fi
}

for dir in 19*/
do
    buildListOfTables
    buildListOfFigures
    buildListOfListings
done
