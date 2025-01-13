#!/bin/bash
help_prompt(){
    echo "Aufruf: ./ltar [OPTION]... [DATEI/ORDNER]
    Verschlüsselung und Komprimierung von Dateien oder Verzeichnissen mithilfe von LUKS
      -j, --bzip2       Archiv durch bzip2 filtern
      -J, --xz          Archiv durch xz filtern 
          --lzip        Archiv durch lzip filtern
          --lzop        Archiv durch lzop filtern
      -h, --help        Gibt Hilfe zum Tool aus
      -q, --quiet       Unterdrückt Ausgabe von Informationen
      -x                Die Datei wird extrahiert
      -c                Eine Datei wird erstellt
    "
}
