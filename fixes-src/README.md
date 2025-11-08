# fixes-src

Katalog z poprawkami do projektu **[Apache SuperSet](https://github.com/apache/superset)**. Opis zmian znajdziesz w pliku [CHANGELOG](CHANGELOG.md). Katalog zawiera wszelkie poprawki niezbędne do wdrożenia produktu **Apache SuperSet** wraz z oczekiwaną funkcjonalnością. Zachowana jest oryginalna struktura katalogów projekktu Apache SuperSet.

## Instalalcja poprawek do aplikacji

Aby zainstalować poprawki należy skopiować pliki z tego katalogu do katalogu z projektem **Apache SuperSet** z odpowiednim punktem zatwierdzenia. Możemy się w tym celu posiłkować sktyptem `03-install.sh` znajdującym się w katalogu głównym projektu **superset-fixes**. Załóżmy, że projekt **Apache SuperSet** został juz załadowany i znajduje się w  katalogu `superset-6.0-sci`. Przed jego użyciem skryptu edytuj go (zmień jeśli trzeba) i pamiętaj o ustawieniu odpowiednich wartości zmiennych `SOURCE_PATH` oraz `TARGET_PATH`:

```bash title="../03-install.sh"
# SOURCE_PATH - katalog z poprawkami.
export SOURCE_PATH="fixes-src"
# SOURCE_PATH - katalog z docelowym projketem Apache SuperSet 
export TARGET_PATH="superset-6.0-sci"
```

Po wprowadzeniu odpowiednich zmian uruchom go:

```bash
# Przejdź do katalogu głownego projektu superset-fixes.
cd ..
./03-install.sh
```
