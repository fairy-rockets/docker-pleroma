# これは何？

Pleromaインスタンス、[鯖とサバトを](https://sabbat.hexe.net/)のDockerComposeスクリプト

# How to use

## Install

### 前提条件

 - PleromaのプロセスはGID=1000/UID=1000で動かすものとします。
 - PleromaもHTTPSを利用する機能があるが、そこはnginxに任せる。
 - docker/docker-composeはセットアップしてあるものとする

### ソースコードの入手

```bash
git clone git@github.com:fairy-rockets/docker-pleroma.git
cd docker-pleroma
git clone git@github.com:fairy-rockets/sabbat.git pleroma
```

### データフォルダの作成

```bash
mkdir -p data/postgres
mkdir -p data/uploads
```

### Postgresの起動とcitextの有効化

PostgreSQLの`citext`（大文字小文字を無視して検索する機能らしい）が必要らしいので、それを有効にする。

```sh
docker-compose up -d postgres
docker exec -i pleroma_postgres psql -U pleroma -c "CREATE EXTENSION IF NOT EXISTS citext;"
```

### Pleromaの設定

pleroma/config/prod.secret.exsを次のようにする：

```exs
use Mix.Config

config :pleroma, Pleroma.Web.Endpoint,
  url: [scheme: "https", host: "sabbat.hexe.net", port: 443],
  protocol: "http",
  secret_key_base: "<use 'openssl rand -base64 48' to generate a key>"

config :pleroma, :instance,
  name: "妖精⊸ロケット / 鯖とサバトを",
  email: "psi@*io.org",
  limit: 2048,
  registrations_open: false

# Configure your database
config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pleroma",
  password: "***ひみつ***",
  database: "pleroma",
  hostname: "postgres",
  pool_size: 10

# docker-compose run --rm web mix web_push.gen.keypairの結果
config :web_push_encryption, :vapid_details,
  subject: "mailto:administrator@example.com",
  public_key: "*****",
  private_key: "*****"

```

### ビルド

Postgresはできあいのものを利用しているので、ビルドしなくてよい。Pleromaのみビルドする。

ただし、設定ファイルを書き換えるたびにビルドしないといけない（TODO: 結構掛かるのでここを短縮したい）。

```sh
docker-compose build
# or
docker build -t pleroma .
```

### DBの設定

```sh
docker-compose run --rm web mix ecto.migrate
```

### 起動！

```bash
docker-compose up -d
```

### ログをチェックする

```bash
docker logs -f pleroma_web
```

### nginxの設定をする

公式サイトの[Nginx config](https://git.pleroma.social/pleroma/pleroma/blob/develop/installation/pleroma.nginx)を参考にする。

## Update

```sh
docker-compose pull # update the PostgreSQL if needed
docker-compose build .
# or
docker build -t pleroma .
docker-compose run --rm web mix ecto.migrate # migrate the database if needed
docker-compose up -d # recreate the containers if needed
```

# Other Docker images

Here are other Pleroma Docker images that helped me build mine:

- [potproject/docker-pleroma](https://github.com/potproject/docker-pleroma)
- [rysiek/docker-pleroma](https://git.pleroma.social/rysiek/docker-pleroma)
- [RX14/iscute.moe](https://github.com/RX14/kurisu.rx14.co.uk/blob/master/services/iscute.moe/pleroma/Dockerfile)
