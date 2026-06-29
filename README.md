# Podstawy_programowania
# WZIMK Lo3

Repozytorium z zadaniami projektowymi z przedmiotu Podstawy Programowania.
Środowisko: MSYS2 (UCRT64) na Windows


# Zadanie 2 - Instalacja MSYS2
Zainstalowano MSYS2 z oficjalnej strony, miejsce docelowe: dysk `G:\msys2`.
## Aktualizacja systemu
```bash
pacman -Syu
```

- `-S` – synchronizuj/instaluj
- `-y` – odświezanie listy dostępnych pakietów
- `-u` – aktualizacja już zainstalowanych pakietów

  ## Instalacja potrzebnych narzędzi
```bash
pacman -S vim nano less diffutils zip unzip dos2unix patch mingw-w64-ucrt-x86_64-imagemagick
```

- `-S` – instalacja pakietów wymienionych po -S

# Zadanie 3 – Niesforne dane 
## Rozpakowanie i konwersja końców linii
```bash
cd /G/projekt_podstawy_programowania
unzip dane.zip
dos2unix dane.txt
```

## Zamiana jednej kolumny na trzy
```bash
paste - - - < dane.txt > Kolumny.txt
```

Program `paste` z trzema myślnikami bierze po trzy kolejne wiersze i skleja je
obok siebie w jeden wiersz. `< dane.txt` wskazuje plik źródłowy.
  
## Nagłówek i połączenie z danymi
```bash
echo -e "x\ty\tz" > naglowki.txt
cat naglowki.txt Kolumny.txt > zad3.txt
```

- `echo -e` – wypisuje tekst, `-e` interpretuje `\t` jako tabulator
- `cat` – łączy pliki jeden za drugim (najpierw `naglowki.txt`, potem `Kolumny.txt`)

## Sprawdzenie wyniku
```bash
head -n 5 zad3.txt
```

# Zadanie 4 – Dodawanie poprawek
## Rozpakowanie i konwersja
```bash
unzip lista.zip
dos2unix lista.txt lista-pop.txt
```

## Tworzenie łatki
```bash
diff -u lista.txt lista-pop.txt > lista.patch
```

- `diff` – porównuje dwa pliki i pokazuje różnice
- `-u` – format ujednolicony (z kontekstem)

## Sumy kontrolne przed naprawą
```bash
md5sum lista.txt lista-pop.txt
```

`md5sum` liczy unikalny skrót zawartości pliku – różna treść = różny skrót.

## Nałożenie łatki i ponowna weryfikacja
```bash
patch lista.txt < lista.patch
md5sum lista.txt lista-pop.txt
```

`patch` czyta plik `lista.patch` i wprowadza zmiany do `lista.txt`.

# Zadanie 5 – Z CSV do SQL i z powrotem
## Konwersja końców linii
```bash
dos2unix steps-2sql.csv steps-2csv.sql
```

## Z CSV do SQL
```bash
awk -F';' 'NR > 1 {print "INSERT INTO stepsData (time, intensity, steps) VALUES (" $1 ", " $2 ", " $3 ");"}' steps-2sql.csv > steps-2sql.sql
```

- `awk` – przetwarza plik linia po linii, z podziałem na kolumny
- `-F';'` – kolumny rozdzielone średnikiem
- `NR > 1` – pomija nagłówek (pierwszą linię)
- `$1`, `$2`, `$3` – kolumny: czas, intensywność, kroki

## Z SQL do CSV (bez 3 zer z daty)
```bash
echo "dataTime; steps; synced" > steps2csv.csv
sed -E 's/.*VALUES \(([0-9]+)000, *([0-9]+), *([0-9]+)\);/\1;\2;\3/' steps-2csv.sql >> steps2csv.csv
```

- `sed -E` – zamiana tekstu wg wzorca, `-E` włącza czytelniejszy zapis nawiasów
- `([0-9]+)000` – zapamiętuje cyfry, ale trzy zera `000` zostają poza nawiasem (czyli giną)
- `\1`, `\2`, `\3` – odwołania do zapamiętanych liczb
- `>>` – dopisuje na koniec pliku (nie nadpisuje)

## Sprawdzenie wyniku
```bash
head -n 4 steps2csv.csv
```

# Zadanie 6 – Tłumacz
## Część 1 – pl-7.2.json5 (dublowanie linii)
```bash
{
  head -n 1 en-7.2.json5
  sed -n '2,$p' en-7.2.json5 | sed '$d' | while read -r linia; do
      echo "// $linia"
      echo "$linia"
  done
  tail -n 1 en-7.2.json5
} > pl-7.2.json5
```
- `head -n 1` / `tail -n 1` – zostawiają nawiasy `{` i `}` bez zmian
- `sed -n '2,$p' | sed '$d'` – wycina czysty środek pliku (bez nawiasów)
- `while read -r linia; do ... done` – dla każdej linii wypisuje ją jako komentarz (`// $linia`) i normalnie (`$linia`)

## Część 2 – wykrycie nowych fraz (nowe.txt)
```bash
sed -n '2,$p' en-7.4.json5 | sed '$d' | while read -r linia; do
    klucz=$(echo "$linia" | cut -d\" -f2)
    if ! grep -q "\"$klucz\"" en-7.2.json5; then
        echo "$linia"
    fi
done > nowe.txt
```

- `cut -d\" -f2` – wycina klucz (tekst między 1. i 2. znakiem `"`)
- `grep -q` – sprawdza po cichu, czy klucz istnieje w starym pliku
- `if ! grep -q ...` – warunek prawdziwy, gdy klucza NIE znaleziono (czyli fraza jest nowa)

## Część 3 – dublowanie nowe.txt z komentarzem
```bash
{
  echo "{"
  while read -r linia; do
      echo "// $linia"
      echo "$linia"
  done < nowe.txt
  echo "}"
} > pl-7.4.json5
```
Plik `pl-7.4.json5` zawiera tylko nowe frazy, wymagające tłumaczenia.

# Zadanie 7 – Fotografik
## Rozpakowanie
Archiwa `kopie-1.zip` i `kopie-2.zip` rozpakowano przez 7-zip.

## Konwersja zdjęć (JPG, 720px, DPI 96x96)
```bash
find kopie-1 kopie-2 -type f \( -iname "*.png" -o -iname "*.jpg" \) | while read -r plik; do
    nowy="${plik%.*}.jpg"
    magick "$plik" -resize x720 -density 96x96 -units PixelsPerInch "$nowy"
    if [ "$plik" != "$nowy" ]; then
       rm "$plik"
    fi
done
```

- `find ... -type f` – szuka plików rekurencyjnie w obu folderach
- `-iname "*.png" -o -iname "*.jpg"` – pliki PNG albo JPG (wielkość liter nieważna)
- `${plik%.*}.jpg` – ucina rozszerzenie i dopisuje `.jpg`
- `-resize x720` – wysokość 720px, szerokość proporcjonalnie
- `-density 96x96 -units PixelsPerInch` – DPI ustawione na 96x96
- usunięcie starego pliku tylko gdy nazwa się zmieniła (czyli był PNG)

## Spakowanie do jednego ZIP-a
```bash
zip -r zdjecia-gotowe.zip kopie-1 kopie-2
```

# Zadanie 8 – Wszędzie te PDF-y
## Lista zdjęć
```bash
find kopie-1 kopie-2 -type f -iname "*.jpg" | sort > lista.txt
```

## Budowa PDF-a
```bash
mapfile -t pliki < lista.txt
montage -label '%f' "${pliki[@]}" -tile 2x4 -geometry 300x300+10+40 -page a4 portfolio.pdf
```

- `mapfile -t pliki < lista.txt` – wczytuje plik linia po linii do tablicy `pliki`
- `"${pliki[@]}"` – rozwija tablicę tak, żeby każda nazwa pliku trafiła jako jeden argument (działa też ze spacjami w nazwie)
- `-label '%f'` – podpis pod zdjęciem z nazwą pliku
- `-tile 2x4` – 2 kolumny × 4 wiersze = 8 zdjęć na stronie
- `-page a4` – strona PDF w formacie A4

Wynik: `portfolio.pdf` ze wszystkimi zdjęciami, po 8 na stronę, z podpisami nazw plików.

# Zadanie 9 – Porządki w kopiach zapasowych
Skrypt: [`zad9.sh`](zad9.sh)

## Skrypt

```bash
#!/usr/bin/env bash
cd kopie
for plik in *.zip; do
    rok="${plik:0:4}"
    miesiac="${plik:5:2}"
    mkdir -p "$rok/$miesiac"
    mv "$plik" "$rok/$miesiac/"
done
```

- `for plik in *.zip` – pętla po każdym pliku `.zip` w katalogu
- `${plik:0:4}` – wycina 4 pierwsze znaki nazwy pliku (rok)
- `${plik:5:2}` – wycina 2 znaki od pozycji 5 (miesiąc)
- `mkdir -p` – tworzy katalog `rok/miesiąc
- `mv` – przenosi plik do nowego katalogu

## Uruchomienie

```bash
bash zad9.sh
```

## Sprawdzenie wyniku

```bash
find kopie | sort
```
