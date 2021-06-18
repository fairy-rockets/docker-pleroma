.PHONY: all
all: ps ;

.PHONY: up
up: ./var/postgres
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: reload
reload:
	$(MAKE) down
	$(MAKE) up

.PHONY: restart
restart:
	docker-compose restart

.PHONY: build
build:
	docker-compose build

.PHONY: pull
pull:
	docker-compose pull

.PHONY: log
log:
	docker-compose logs -f --tail 0

.PHONY: ps
ps:
	docker-compose ps

.PHONY: top
top:
	docker-compose top

########################################################################################################################
## pleroma
########################################################################################################################

.PHONY: migrate_to_db
migrate_to_db:
	$(MAKE) down
	docker-compose up -d postgres
	docker-compose run --rm web mix pleroma.config migrate_to_db

.PHONY: migrate_from_db
migrate_from_db:
	$(MAKE) down
	docker-compose up -d postgres
	docker-compose run --rm --entrypoint /bin/sh web -c "mix pleroma.config migrate_from_db && cat config/prod.exported_from_db.secret.exs"

########################################################################################################################
## db
########################################################################################################################

.PHONY: migrate
migrate:
	$(MAKE) down
	docker-compose up -d postgres
	docker-compose run --rm web mix ecto.migrate
	$(MAKE) down

.PHONY: backup
backup:
	bash _helpers/backup.sh

.PHONY: db-cli
db-cli:
	docker-compose exec postgres psql --user=pleroma

# -----------------------------------------------------------------------------
# https://makefiletutorial.com/#automatic-variables
./var/postgres:
	mkdir -p "$@"
