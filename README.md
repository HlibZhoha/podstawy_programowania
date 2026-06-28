# podstawy_programowania
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


























