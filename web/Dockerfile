FROM elixir:1.10-alpine as build

COPY ./pleroma .

ENV MIX_ENV=prod

RUN apk add git gcc g++ musl-dev make &&\
        echo "import Mix.Config" > config/prod.secret.exs &&\
	mix local.hex --force &&\
	mix local.rebar --force &&\
	mix deps.get --only prod &&\
	mkdir release &&\
	mix release --path release

FROM alpine:3.12

ARG BUILD_DATE
ARG VCS_REF

ARG HOME=/opt/pleroma
ARG DATA=/var/lib/pleroma

RUN echo "http://nl.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories &&\
	apk update &&\
	apk add ncurses postgresql-client &&\
	adduser --system --shell /bin/false --home ${HOME} pleroma &&\
	mkdir -p ${DATA}/uploads &&\
	mkdir -p ${DATA}/static &&\
	chown -R pleroma ${DATA} &&\
	mkdir -p /etc/pleroma &&\
	chown -R pleroma /etc/pleroma

USER pleroma

COPY --from=build --chown=pleroma:0 /release ${HOME}

COPY ./prod.secret.exs /etc/pleroma/config.exs
COPY ./entrypoint.sh ${HOME}

EXPOSE 4000

ENTRYPOINT ["/opt/pleroma/entrypoint.sh"]
