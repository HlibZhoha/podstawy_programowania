# podstawy_programowania
WZIMK Lo3

zadanie 3 Niesforne dane
Opis postępowania:
1 przejscie do mojego ktalogu z zipem `$ cd /G/projekt_podstawy_programowania`;

2. Rozpakowano archiwum z danymi przy użyciu narzędzia `unzip`:
   `$ unzip dane.zip`
3. Przekonwertowano znaki końca linii z formatu Windows (CRLF) na format Linux (LF):
`   $ dos2unix dane.txt
dos2unix: converting file dane.txt to Unix format...`
4.Zamiana jednej kolumny na trzy kolumny
Program paste z trzema myślnikami. Myślniki oznaczają: "weź linię 1, linię 2, linię 3 i sklej je obok siebie, potem weź linię 4, 5, 6 i zrób to samo". Wynik zapiszemy do tymczasowego pliku kolumny.txt
Znaczek < dane.txt mówi konsoli: "Weź ten plik i nakarm nim program".

Wtedy trzy myślniki - - - mogą pobrać z tego pliku po trzy linijki na raz i ładnie ułożyć je w kolumny.
`$ paste - - - < dane.txt > Kolumny.txt`
5. sprawdaz wynik działania przez `nano Kolumny.txt `

6. Wygenerowanie nagłówek kolumn x y z z separatorami tabulacji, w nowym pliku
   `$ echo -e "x\ty\tz" > naglowki.txt`
7. Połączenie nagłówki.txt z przetworzonymi danymi kolumny.txt za pomocą cat:
`cat naglowek.txt kolumny.txt > zad3.txt`
8. sprawdzenie rezultatu `nano zad3.txt`

zadanie 4 Dodawanie poprawek 
1. pobranie plikow lista-pop.txt  lista.txt
2. `GlibZ@Aboba UCRT64 /G/projekt_podstawy_programowania/zad4
$ ls
lista-pop.txt  lista.txt  lista.zip`
3. Przekonwertowano znaki końca linii z formatu Windows (CRLF) na format Linux (LF):
   `$ dos2unix lista.txt lista-pop.txt
dos2unix: converting file lista.txt to Unix format...
dos2unix: converting file lista-pop.txt to Unix format...`
4.Teraz stworzymy plik, który zawiera tylko informacje o tym, czym te dwie listy się różnią
`$ diff -u lista.txt lista-pop.txt > lista.patch`
tworzy sie plik typu .path

5.Sprawdź sumy kontrolne (Przed naprawą)
Teraz sprawdzimy unikalne "odciski palca" obu plików za pomocą algorytmu MD5
`$ md5sum lista.txt lista-pop.txt`

6.Nałóż łatkę na oryginalny plik
Teraz zrobimy magię – użyjemy pliku .patch, żeby automatycznie naprawić stary plik lista.txt
`$ patch lista.txt < lista.patch
patching file lista.txt`

 7.Wielka weryfikacja (Po naprawie)
Skoro plik lista.txt został zaktualizowany, teraz powinien być dokładnie taki sam jak lista-pop.txt. Sprawdźmy to ponownie sumami MD5
`$ md5sum lista.txt lista-pop.txt
683c1c85343c7337adfb13acb7598237 *lista.txt
683c1c85343c7337adfb13acb7598237 *lista-pop.txt
`Sukces jest wtedy, kiedy oba długie ciągi znaków na ekranie są teraz IDENTYCZNE


zadanie 5 Z CSV do SQL i z powrotem
1.Standardowo zaczynamy od wyciągnięcia plików i ujednolicenia końcówek linii, żeby narzędzia Linuxowe się nie pogniewały
`$ dos2unix steps-2sql.csv steps-2csv.sql`
2.Musimy przerobić plik, gdzie dane są oddzielone średnikami, na serię zapytań bazodanowych INSERT INTO. Użyjemy do tego programu awk, który potrafi przetwarzać pliki linia po linii i dzielić je na kolumny.
`$ awk -F';' 'NR > 1 {print "INSERT INTO stepsData (time, intensity, steps) VALUES (" $1 ", " $2 ", " $3 ");"}' steps-2sql.csv > steps-2sql.sql`

3. sprawdzam wynik działania
`$ head -n 3 steps-2sql.sql
INSERT INTO stepsData (time, intensity, steps) VALUES (1562001120, 19, 0);
INSERT INTO stepsData (time, intensity, steps) VALUES (1562001180, 23, 0);
INSERT INTO stepsData (time, intensity, steps) VALUES (1562001240, 13, 0);`

4.Z SQL do CSV z ucinaniem trzech ostanich zer z daty (Praca z sed) 

5.nowy plik CSV z wymaganym nagłówkiem
`$ echo "dataTime; steps; synced" > steps2csv.csv`

6.Wyciągnij dane i utnij zera za pomocą sed
`$ sed -E 's/.*VALUES \(([0-9]+)000, *([0-9]+), *([0-9]+)\);/\1;\2;\3/' steps-2csv.sql >> steps2csv.csv`

7.Sprawdźmy, czy Twój nowy plik CSV wygląda dokładnie tak jak trzeba
`$ head -n 4 steps2csv.csv
dataTime; steps; synced
1562004600;41;0
1562005200;65;0
1562005800;86;0`









