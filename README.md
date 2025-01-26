# ltar
With LUKS encrypted tar-balls


### Run

Using malscent's !["bash_bundler"](https://github.com/malscent/bash_bundler)

```sh
./bundle.sh
```

run with 
```
./build/ltar.sh [OPTION]... [Output] [Dateien]
    Verschlüsselung und Komprimierung von Dateien oder Verzeichnissen mithilfe von LUKS
      -j, --bzip2       Archiv mit bzip2 komprimieren
      -J, --xz          Archiv mit xz komprimieren 
      -h, --help        Gibt Hilfe zum Tool aus
      -q, --quiet       Unterdrückt Ausgabe von Informationen
      -x                Die Datei wird extrahiert
      -c                Eine Datei wird erstellt
```
