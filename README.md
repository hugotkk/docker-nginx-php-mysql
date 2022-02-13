
** This repo is cloned from https://github.com/nanoninja/docker-nginx-php-mysql for personal usage **

```
git clone https://github.com/hugotkk/docker-nginx-php-mysql
cd docker-nginx-php-mysql
```

```
make gen-certs
```

```
docker-compose up -d
```

place sql to data/db/db.sql

```
make mysql-restore
```

place php code to web/public

mysql info can be found at .env
