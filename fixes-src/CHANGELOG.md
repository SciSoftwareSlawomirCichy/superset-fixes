# Log zmian do `de5ca7980563851aabb953d0cbd05d527ce41cbb`

Zmiany konieczne do konfiguracji głównego kontekstu aplikacji Apache SuperSet. Po mimo istnienia oficjalnego dokumentu [Configuring the application root](https://superset.apache.org/docs/configuration/configuring-superset/#configuring-the-application-root) opisującego jak zmienić głównny kontekst aplikacji, to opisany mechanizm nie do końca działa (jeżeli można tak to opisać). Główną przyczyną jest brak wcześniejszego założenia by aplikacja działała w takim trybie. Przeanalizowałem kod i poprawiłemm błędy. Niestety nie mam czasu by zrobić to porządnie, by odpowiednio sparametryzwoać aplikację. W niektórych przypadkach po prostu zahardkodowałem kontekst aplikacji. Wprowadzone przeze mnie zmiany sprawiają, że aplikacja działa poprawnie w kontekścice `/analytics`.

> [!WARNING]
> Ograniczennia czasowe spowodowały, że wprowadzone do projektu zmiany nie parametryzują go w pełni, a wprowadzają stały kontetkst aplikacji `/analytics`.

## Zmiana kontekstu aplikacji

W celu naprawienia mechanizmów przeniesienia głównego kontekstu z `/` do `/analytics` wprowadzono nanstępujące zmiany w kodzie aplikacji i jej konfiguracji.

### `superset/initialization/__init__.py`

Zmiana ustwień linku przy ikonce aplikacji "Home" w linii 292.

```py title="/superset/superset/initialization/__init__.py: 292"
    appbuilder.add_link(
        "Home",
        label=_("Home"),
        // highlight-next-line
        href= f"{app_root}/superset/welcome/",
        cond=lambda: bool(current_app.config["LOGO_TARGET_PATH"]),
    )
```

Było `href="/superset/welcome/"`.

### `superset/config.py`

Zmieniono URL'a do ikonki aplikacji w linii 332. Bardzoz możliwe, że tą zmianę można jakoś wymusić przez odpowiednią konfigurację, jakiś dodatkowy plik, ale nie mam czasu na analizy. Na razie wprowadzono na sztywno wartość "domyślną" rozpoczynającą się od `/analytics`.

```py title="/superset/superset/config.py: 332"
APP_ICON = "/analytics/static/assets/images/superset-logo-horiz.png"
```

Było `APP_ICON = "/static/assets/images/superset-logo-horiz.png"`.

Był problem z kolejnością ładowania parametrów. Ze względu na następną, konieczną zmianę parametryzacji przeniesiono `STATIC_ASSETS_PREFIX` z linii 1966 do linii 336 i ustawiono waratość domyślną `/analytics`.

```py title="/superset/superset/config.py: 336"
# Optional prefix to be added to all static asset paths when rendering the UI.
# This is useful for hosting assets in an external CDN, for example
STATIC_ASSETS_PREFIX = "/analytics"
```

Było `STATIC_ASSETS_PREFIX = ""` w linii 1966.

Dzięki zmianom związanym z `STATIC_ASSETS_PREFIX` można było wprowadzić poprawkę w definicji `THEME_DEFAULT` linia 750:

```py title="/superset/superset/config.py: 750"
# Default theme configuration - foundation for all themes
# This acts as the base theme for all users
THEME_DEFAULT: Theme = {
    "token": {
        # Brand
        "brandLogoAlt": "Apache Superset",
        "brandLogoUrl": APP_ICON,
        "brandLogoMargin": "18px",
        "brandLogoHref": STATIC_ASSETS_PREFIX,
        "brandLogoHeight": "24px",
        # Spinner
        "brandSpinnerUrl": None,
        "brandSpinnerSvg": None,
        # Default colors
        "colorPrimary": "#2893B3",  # NOTE: previous lighter primary color was #20a7c9 # noqa: E501
        "colorLink": "#2893B3",
        "colorError": "#e04355",
        "colorWarning": "#fcc700",
        "colorSuccess": "#5ac189",
        "colorInfo": "#66bcfe",
        # Fonts
        "fontFamily": "Inter, Helvetica, Arial",
        "fontFamilyCode": "'Fira Code', 'Courier New', monospace",
        # Extra tokens
        "transitionTiming": 0.3,
        "brandIconMaxWidth": 37,
        "fontSizeXS": "8",
        "fontSizeXXL": "28",
        "fontWeightNormal": "400",
        "fontWeightLight": "300",
        "fontWeightStrong": "500",
    },
    "algorithm": "default",
}
```

Było na sztywno ustawione `"brandLogoHref": "/",`.

### `superset-frontend/src/pages/Login/index.tsx`

W pliku są mechanizmy obsługujące okno logowania, które przyjmuje parametr `next` metodą `GET`. Niestety obecnie zaimplementowany mechanizm nie bierze pod uwagę możliwości zmiany kontekstu aplikacji. Wprowadzono zmianę obsługi wartości parametru `next`.

W linii 95 zmieniono budowanie url'a.

```tsx title="/superset/superset-frontend/src/pages/Login/index.tsx linia: 95"
  const loginEndpoint = useMemo(
    // highlight-next-line
    () => (nextUrl ? `/login/?next=%2Fanalytics${encodeURIComponent(nextUrl)}` : '/login/'),
    [nextUrl],
  );
```

Było `next=${encodeURIComponent(nextUrl)}`, bez `%2Fanalytics`.

W linii 102 zmieniono budowanie url'a.

```tsx title="/superset/superset-frontend/src/pages/Login/index.tsx linia: 102"
  const buildProviderLoginUrl = (providerName: string) => {
    const base = `/login/${providerName}`;
    return nextUrl
      ? `${base}${base.includes('?') ? '&' : '?'}next=%2Fanalytics${encodeURIComponent(nextUrl)}`
      : base;
  };
```

Było `next=${encodeURIComponent(nextUrl)}`, bez `%2Fanalytics`.

### `superset-frontend/packages/superset-ui-core/src/connection/SupersetClientClass.ts`

Podobnie jak w poprzednim przypadku. W pliku są mechanizmy obsługujące okno logowania, które przyjmuje parametr `next` metodą `GET`. Niestety obecnie zaimplementowany mechanizm nie bierze pod uwagę możliwości zmiany kontekstu aplikacji. Wprowadzono zmianę obsługi wartości parametru `next`.

W linii 38 zmieniono budowanie url'a.

```ts title="/superset/superset-frontend/packages/superset-ui-core/src/connection/SupersetClientClass.ts linia: 95"
const defaultUnauthorizedHandlerForPrefix = (appRoot: string) => () => {
  if (!window.location.pathname.startsWith(`${appRoot}/login`)) {
    window.location.href = `${appRoot}/login?next=%2Fanalytics${window.location.href}`;
  }
};
```

Było `/login?next=${window.location.href}`, bez `%2Fanalytics`.

>[!NOTE]
> Poniżej lista plików, którym należy się przyjrzeć czy czasem nie sprawią kłopotów podczas zmiany kontekstu głównego aplikacji⁉️

| Plik  | Lokalizacja zagrożenia |
| :--- | :--- |
| `src/views/routes.tsx` | W linii 181 znajduje się definicja `export const routes: Routes = {}`. Na razie nie zauważyłem impaktu (wpływu) na odpowiednią komunikacjcę pomiędzy poszczególnymi komponentami aplikacji, ale trzeba mieć ją na uwadze. |

## Zmiany konfiguracji budowania aplikacji

Aby poprawić funkcjonalność pracy w środowisku kontenerowym, wprowadzono szereg zmian w konfiguracji budowania i uruchamiania aplikacji.

### `superset-frontend/package.json`

Dodano skrypt `docker-container`, który pozwala na poprawne uruchomienie apilacji w środwisku kontenerowym:

```json title="/superset/superset-frontend/package.json linia: 51"
  "dev-server": "cross-env NODE_ENV=development BABEL_ENV=development node --max_old_space_size=4096 ./node_modules/webpack-dev-server/bin/webpack-dev-server.js --mode=development",
  // highlight-next-line
  "docker-container": "cross-env WEBPACK_DEVSERVER_HOST='0.0.0.0' superset=http://superset:8088 NODE_ENV=development BABEL_ENV=development node --max_old_space_size=4096 ./node_modules/webpack-dev-server/bin/webpack-dev-server.js --mode=development",
  "eslint": "eslint --ignore-path=.eslintignore --ext .js,.jsx,.ts,tsx --quiet",
```

### `superset-frontend/webpack.config.js`

Poprawiono konfigurację aplikacji tak aby przyjmowała ruch z "zewnątrz" (linia 640).

```js title="/superset/superset-frontend/webpack.config.js linia: 640"
    port: devserverPort,
    // highlight-next-line
    allowedHosts: ['all'],
    proxy: [() => proxyConfig],
```

Było `allowedHosts: ['localhost', '.localhost', '127.0.0.1', '::1', '.local'],`.

Podniesiono poziom logowania zdarzeń do poziomu informacji (linia 648).

```js title="/superset/superset-frontend/webpack.config.js linia: 648"
    client: {
      overlay: {
        errors: true,
        warnings: false,
        runtimeErrors: error => !/ResizeObserver/.test(error.message),
      },
      // highlight-next-line
      logging: 'info',
      webSocketURL: {
        hostname: '0.0.0.0',
        pathname: '/ws',
        port: 0,
      },
    },
```

Było `logging: 'error',`.

### `superset-frontend/webpack.proxy-config.js`

W celu weryfikacji, czy w środowisku kontenerowym zostały załadowane prawidłowe parametry, wprowadzono dodatakowe logowanie zdarzeń z prezentacją ich ustawień.

```js title="/superset/superset-frontend/webpack.proxy-config.js linia: 34"
// highlight-start
console.log('--- PROXY INFO START ---');
console.log(`1. Value of parsedArgs.env: ${parsedArgs.env}`);
console.log(`2. Value of supersetPort: ${supersetPort}`);
console.log(`3. Value of supersetUrl: ${supersetUrl}`);
// highlight-end

const backend = (supersetUrl || `http://localhost:${supersetPort}`).replace(
  '//+$/',
  '',
); // strip ending backslash

// highlight-start
console.log(`4. End value of backend: ${backend}`);
console.log('--- PROXY INFO END ---');
// highlight-end
```

## Poprawienie budowania i uruchomienia aplikacji w środowisku Docker

Podczas pierwszego uruchomienia aplikacji w środowisku kontenerowym pojawiły się błędy. Przeprowadzono analizę i wprowadzono nstępujące zmmiany w definicji budowania obrazów oraz konfiguracji aplikacji.

### `docker-compose.yml`

Na bazie oryginalnego pliku `docker-compose.yml` zbudowanno definicję kompozycji, w której uzupełniono/zmieniono:

* Zmieniono definicję obrazu `superset-cache` z `apache/superset-cache:3.10-slim-trixie` na `apache/superset-cache:3.10-slim-bookworm`.
* Dodano konfigurację sieci pomiędzy kontenerami:

```yaml title="/superset/docker-compose.yml"
networks:
  superset-network:
    driver: bridge
    
```

* Dodano do definicji kontenerów parametry `hostname` oraz `network`. Uzupełniono `links` pozwalające na zbudowanie poprawniej zależności między kontenerami.Poniżej przykład konfiguracji kontenera `superset`.

```yaml title="/superset/docker-compose.yml"
    hostname: superset
    networks:
      - superset-network
    links:
      - db
      - redis
      - superset-websocket
```

* Dodano jawną definicję wolumenów lokalnych.

```yaml title="/superset/docker-compose.yml"
volumes:
  superset_home:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${VOLUME_SUPERSET_HOME:-/home/superset/superset_home}
  db_home:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${VOLUME_DB_HOME:-/home/superset/db_home}
  redis:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${VOLUME_REDIS_HOME:-/home/superset/redis}
  superset_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${VOLUME_SUPERSET_DATA:-/home/superset/superset_data}
  superset_websocket_nmp:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${VOLUME_WEBSOCKET_NMP:-/home/superset/superset_websocket_nmp}
  nginx_logs:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${VOLUME_NGINX_LOGS:-/home/superset/nginx_logs}
```

* Wprowadzono szereg innych zmian do pliku `docker-compose.yml` mających na celu poprawienie działania aplikacji w środowisku kontenerowym.

### `docker/.env`

Dodano parametry, które są niezbędne do budowania i uruchomienia aplikacji w środowisku kontenerowym.

* Podstawowe parametry konfiguracji kompozycji:

```properties title="/superset/docker/.env"
SUP_VERSION=superset-6.0-sci
SUP_NODE_VERSION=superset-6.0-sci
SUPERSET_FRONT=1080
SUPERSET_PORT0=10088
SUPERSET_PORT1=10081
SUPERSET_PORT_WEBSOCKET=10080

VOLUME_SUPERSET_HOME=/home/superset/superset_home
VOLUME_DB_HOME=/home/superset/db_home
VOLUME_REDIS_HOME=/home/superset/redis
VOLUME_SUPERSET_DATA=/home/superset/superset_data
VOLUME_WEBSOCKET_NMP=/home/superset/superset_websocket_nmp
VOLUME_NGINX_LOGS=/home/superset/nginx_logs
```

* W linii 69 dodano:

```properties title="/superset/docker/.env linia: 69"
REDIS_SSL=false
```

* W linii 70 zmieniono wartość parametru `SUPERSET_APP_ROOT`:

```properties title="/superset/docker/.env linia: 69"
SUPERSET_APP_ROOT="/analytics"
```

### `docker/docker-frontend.sh`

Zmieniono skrypt uruchamiany w kontenerze. Wcześniej, w opisie zmian pliku `superset-frontend/package.json`, napisano, że dodano skrypt `docker-container`. W pliku uruchamiającym zostanie on wykorzystany poprzez odpowiednią zmianę:

```bash title="/superset/docker/docker-frontend.sh linia: 39"
    # start the webpack dev server, serving dynamically at http://localhost:9000
    # it proxies to the backend served at http://localhost:8088
    #                                     ^^^^^^^^^^^^^^^^^^^^^ no i to jest problemm 
    #npm run dev-server
    # Utworzyłem nowy skrypt w package.json, który uruchamia proxy dla http://superset:8088
    npm run docker-container
```

### `docker/nginx/templates/superset.conf.template`

Dostosowano szablon konfiguracji serwera `Nginx` do wprowadzonych zmian związanych z budową kompozycji.

* W linii 19 zmieniono nazwę kontenera z aplikacją SuperSet:

```conf title="/superset/docker/nginx/templates/superset.conf.template linia: 19"
upstream superset_app {
    server superset:8088;
    keepalive 100;
}
```

* W linii 24 zmieniono nazwę kontenera z aplikacją SuperSet WebSocket:

```conf title="/superset/docker/nginx/templates/superset.conf.template linia: 19"
upstream superset_websocket {
    server superset_websocket:8080;
    keepalive 100;
}
```

* Poprawiono definicję proxy:

```conf title="/superset/docker/nginx/templates/superset.conf.template linia: 31"
server {
    listen 80 default_server;
    server_name  _;
    error_log  /var/log/nginx/superset-error.log;

    location /ws {
        proxy_pass http://superset_websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }

    location ${SUPERSET_APP_ROOT}/static {
        # Proxy to superset-node
        proxy_pass http://superset-node:9000${SUPERSET_APP_ROOT}/static;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }

    location ${SUPERSET_APP_ROOT} {
        proxy_pass http://superset_app${SUPERSET_APP_ROOT};
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        port_in_redirect off;
        proxy_connect_timeout 300;
    }

}
```

### `docker/pythonpath_dev/superset_config.py`

Trzeba było poprawić konfigurację aplikacji, dostosować ją równnież do nowych ustawień związanych z niedomyślnym kontekstem aplikacji ustawionym teraz na `/analytics`.

* Parametry aplikacji i kontekstu:

> [!WARNING]
> Parametr `GLOBAL_ASYNC_QUERIES_JWT_SECRET` musi przyjować taką samą wartość jak pramaetr `"jwtSecret"` w pliku `docker/superset-websocket/config.json`.

```py title="/superset/docker/pythonpath_dev/superset_config.py"
APP_NAME = "Sci Superset"
APP_ICON = "/analytics/static/assets/images/superset-logo-horiz.png"
STATIC_ASSETS_PREFIX = "/analytics"

GLOBAL_ASYNC_QUERIES_JWT_SECRET = "CHANGE-ME-IN-PRODUCTION-GOTTA-BE-LONG-AND-SECRET"
GLOBAL_ASYNC_QUERIES_WEBSOCKET_URL = "ws://superset-websocket:8080/"
GLOBAL_ASYNC_QUERIES_JWT_COOKIE_NAME = "async-token"
```

* Parametry komunikacji z pamięcią podręczną:

```py title="/superset/docker/pythonpath_dev/superset_config.py"
# Global async queries cache backend configuration options:
# - Set 'CACHE_TYPE' to 'RedisCache' for RedisCacheBackend.
# - Set 'CACHE_TYPE' to 'RedisSentinelCache' for RedisSentinelCacheBackend.
GLOBAL_ASYNC_QUERIES_CACHE_BACKEND = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_USER": "",
    "CACHE_REDIS_PASSWORD": "",
    "CACHE_REDIS_DB": REDIS_CELERY_DB,
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_REDIS_SENTINELS": [("localhost", 26379)],
    "CACHE_REDIS_SENTINEL_MASTER": "mymaster",
    "CACHE_REDIS_SENTINEL_PASSWORD": None,
    "CACHE_REDIS_SSL": False,  # True or False
    "CACHE_REDIS_SSL_CERTFILE": None,
    "CACHE_REDIS_SSL_KEYFILE": None,
    "CACHE_REDIS_SSL_CERT_REQS": "required",
    "CACHE_REDIS_SSL_CA_CERTS": None,
}
```

* Parametry włączonych funkcjonalności (włączenie zapytań asynchronicznych):

```py title="/superset/docker/pythonpath_dev/superset_config.py"
FEATURE_FLAGS = {"ALERT_REPORTS": True, "GLOBAL_ASYNC_QUERIES": True}
```

### `docker/superset-websocket/config.json`

Wprowadzono zmiany związane z nazwą hosta kontenera z pamięcią podręczną `redis` (linia 13) oraz sformatowoano plik:

```json title="/superset/docker/superset-websocket/config.json linia: 13"
{
  "port" : 8080,
  "logLevel" : "info",
  "logToFile" : false,
  "logFilename" : "app.log",
  "statsd" : {
    "host" : "127.0.0.1",
    "port" : 8125,
    "globalTags": []
  },
  "redis" : {
    "port" : 6379,
    "host" : "redis",
    "db" : 0,
    "ssl" : false
  },
  "redisStreamPrefix" : "async-events-",
  "jwtAlgorithms" : [
    "HS256"
  ],
  "jwtSecret" : "CHANGE-ME-IN-PRODUCTION-GOTTA-BE-LONG-AND-SECRET",
  "jwtCookieName" : "async-token"
}
```
