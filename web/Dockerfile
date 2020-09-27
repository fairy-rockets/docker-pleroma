FROM elixir:1.10-alpine

ENV UID=1000 \
    GID=1000 \
    MIX_ENV=prod

RUN echo "http://nl.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories &&\
	apk -U upgrade &&\
	apk add --no-cache \
        exiftool imagemagick ncurses postgresql-client \
        build-base git gcc g++ musl-dev make cmake

RUN addgroup -g ${GID} pleroma \
    && adduser -h /pleroma -s /bin/sh -D -G pleroma -u ${UID} pleroma

COPY ./pleroma/ /pleroma

WORKDIR pleroma
RUN chown -R pleroma:pleroma /pleroma

USER pleroma
RUN mix local.rebar --force && \
    mix local.hex --force && \
    mix deps.get && \
    mix compile

CMD ["mix", "phx.server"]

