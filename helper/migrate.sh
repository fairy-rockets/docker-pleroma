#! /bin/bash -eu

PROJ_PATH="$(readlink -f "$(cd "$(dirname "$(readlink -f $0)")" && pwd)")"
cd "${PROJ_PATH}/.."

docker-compose down
docker-compose run --rm web mix ecto.migrate
