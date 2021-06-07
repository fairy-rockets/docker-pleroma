
.PHONY:log
log:
	docker-compose logs -f --tail 100

########################################################################################################################
## up/down/restart
########################################################################################################################

.PHONY:up
up:
	docker-compose up -d

.PHONY:down
down:
	docker-compose down

.PHONY: restart
restart:
	$(MAKE) down
	$(MAKE) up

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

.PHONY: cli-db
cli-db:
	docker-compose exec postgres psql --user=pleroma
