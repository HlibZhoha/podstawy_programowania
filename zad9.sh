 #!/usr/bin/env bash
cd kopie
for plik in *.zip; do
    rok="${plik:0:4}"
    miesiac="${plik:5:2}"
    mkdir -p "$rok/$miesiac"
    mv "$plik" "$rok/$miesiac/"
done
