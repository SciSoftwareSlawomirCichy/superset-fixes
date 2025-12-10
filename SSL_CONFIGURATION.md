# Instalacja SSL

## Aktualizacja projektu `superset-fixes`

```bash
cd workspace/git/superset-fixes/
git reset --hard HEAD
git pull
chmod a+x ./bin/*
```

## Wprowadzenie poprawek do kompozycji

Trzeba wprowadzić następujące zmiany w definicji kompozycji Docker'a.

>[!NOTE]
> Akcje wykonaj z poziomu katalogu głównego projektu `superset-fixes`

- Ustawiamy zmienną środowiskową `VOLUME_NGINX_DATA` w pliku `.env`. Celem jest dodanie wolumenu, w którym będą przechowywane certyfikaty SSL.:
```bash
vim ../superset-6.0-sci/docker/.env
```
```text
VOLUME_NGINX_DATA=/opt/superset/nginx_data
```

- Tworzymy katalog na  certyfikaty:
```bash
mkdir -p /opt/superset/nginx_data
```

- Uzupełniamy definicję kompozycji `docker-compose.yml`:
```bash
vim ../superset-6.0-sci/docker-compose.yml
```
- W sekcji odpowiedzialnej za kontener `nginx` dodajemy montowanie nowego katalogu`- nginx_data:/opt:rw`:
```yaml
  nginx:
    env_file:
      - path: docker/.env # default
        required: true
      - path: docker/.env-local # optional override
        required: false
    image: nginx:latest
    container_name: superset_nginx
    hostname: nginx
    networks:
      - superset-network
    links:
      - superset
      - superset-websocket
#      - superset-node
    restart: unless-stopped
    ports:
      - "${SUPERSET_FRONT:-80}:80"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./docker/nginx/templates:/etc/nginx/templates:ro
      - nginx_logs:/var/log/nginx:rw
      - nginx_data:/opt:rw
```

- W sekcji odpowiedzialnej za volumeny dodajemy definicję:
```yaml
  nginx_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${VOLUME_NGINX_DATA:-/home/superset/nginx_data}
```

## Instalacja SSL

Do katalogu `/opt/superset/nginx_data` kopiujemy certyfikaty np.:
```bash
[root@baw nginx_data]# ls -la /opt/superset/nginx_data
total 24
drwxr-xr-x 2 root   root    126 Dec 10 21:37 .
drwxr-xr-x 9 root   root    142 Dec 10 21:23 ..
-rw------- 1 197610 197610 3607 Feb 17  2025 scisoftware_intermediate_ca_chain.crt
-rw-rw---- 1 197610 197610 5831 Oct  6 17:44 server-cert-chain.crt
-rw-rw---- 1 197610 197610 6378 Oct  6 17:44 server-cert.crt
-rw------- 1 197610 197610 1704 Oct  6 17:44 server-cert.ke
```

Powyższy katalog podłączony jest do punktu zamontowania `/opt`
```bash
vim ../superset-6.0-sci/docker/nginx/templates/superset.conf.template
```

Poprawiamy template konfiguracji nginx ustawiając SSL na porcie `80`:
```text
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

upstream superset_app {
    server superset:8088;
}

upstream superset_websocket {
    server superset_websocket:8080;
}

server {
    listen 80 default_server ssl;
    listen [::]:80 ssl;
    server_name _;
    error_log  /var/log/nginx/superset-error.log;

    ssl_certificate          /opt/server-cert-chain.crt;
    ssl_certificate_key      /opt/server-cert.key;
    ssl_trusted_certificate  /opt/scisoftware_intermediate_ca_chain.crt;

    location /ws {
        proxy_pass http://superset_websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
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

## Restart 

Restartowanie kompozycji:

```bash
./bin/superset-compose-service.sh restart
```