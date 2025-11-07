# superset-fixes

Wprowadzanie proprawek do projketu Apache SuperSet.

## Przygotowanie repozytorium GIT aplikacji Apache SuperSet

Poprawki zostały przygotowane dla wersji aplikacji z identyfikatorem zatwierdzenia przechowywanym w pliku `commit-id.txt`.

Sklonuj repozytorium Superset w terminalu za pomocą następującego polecenia:

```bash
git clone --depth=1 https://github.com/apache/superset.git superset-<version>
```

gdzie `<version>` to wartrość dla przygotowywanej przez nas wersji np. `6.0-sci`.

Po pomyślnym zakończeniu tego polecenia w bieżącym katalogu powinien pojawić się nowy folder np. `superset-6.0-sci`.
Ładujemy obsługiwany przez nas commit o id `de5ca7980563851aabb953d0cbd05d527ce41cbb`:

```bash
cd superset-6.0-sci
git fetch origin de5ca7980563851aabb953d0cbd05d527ce41cbb
git checkout de5ca7980563851aabb953d0cbd05d527ce41cbb
```

Po wykonaniu `checkout` możemy sprawdzić czy jesteśmy w odpowiednim commit, dla którego zostały przygotowane poprawki:

```bash
cd superset-6.0-sci
git rev-parse HEAD
```

W odpowiedzi na polecenie powinno pojawić się `de5ca7980563851aabb953d0cbd05d527ce41cbb`.

## Instalalcja poprawek do aplikacji

W poprzednim kroku przygotowaliśmy odpowiedną wersję kodów aplikacji. W bierzącym katalogu projektu znajduje się katalog `fixes-src`. Zawiera on wszelkie poprawki niezbędne do wdrożennia produktu wraz z oczerkiwaną funkcjonalnością. Zachowana jest oryginalna struktura katalogów projekktu Apache SuperSet.

Aby zainstalować poprawki należy skopiować pliki z katalogu `fixes-src` do katalogu `superset-6.0-sci`. Możemy się w tym celu posiłkować sktyptem `03-install.sh`. Przed jego użyciem edytuj go i pamietaj o ustawieniu odpowiednich wartości zmiennych `SOURCE_PATH` oraz `TARGET_PATH`:

```bash title="./03-install.sh"
# SOURCE_PATH - katalog z poprawkami.
export SOURCE_PATH="fixes-src"
# SOURCE_PATH - katalog z docelowym projketem Apache SuperSet 
export TARGET_PATH="../superset-6.0-sci"
```

Po wprowadzeniu odpowiednich zmian uruchom go:

```bash
./03-install.sh
```

Katalog ten zawieira plik [CHANGELOG.md](./fixes-src/CHANGELOG.md) opisujący cel i konieczność tych poprawek.

## Skonfigurowanie kompozycji Docker'a

### Przygotowanie wolumenów

### Konfiguracja w pliku `docker/.env`

### Budowa kompozycji

### Uruchomienie kompozycji

### Zatrzymanie kompozycji

## Końcowe uwagi dla developerów

Poprawki wprowadzamy w projecie, którego kody pobraliśmy i przygotowaliśmy metodą opisaną w **Przygotowanie repozytorium GIT aplikacji Apache SuperSet**. Pamietajmy o prowadzeniu listy zmienionych plików i bieżącej aktualizacji skryptów i plików pomocniczych.

| Nazwa pliku | Opis |
| :--- | :--- |
| `01-deploy-test.sh` | Skrypt pomocniczy pozwalający na wysłanie zmian do maszyny, na której testowane jest rozwiązanie. |
| `02-relelase-fixes.sh` | Skrypt pomocniczy pozwalający utworzenie paczki zmian gotowych do instalacji. |
| `03-install.sh` | Skrypt pomocniczy będący podstawą instalacji. Zobacz [README](./fixes-src/README.md) |
