FROM elixir:1.10-alpine

ENV UID=1000 GID=1000 \
    MIX_ENV=prod

RUN apk -U upgrade \
    && apk add --no-cache \
       build-base \
       git

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

VOLUME /pleroma/uploads/

CMD ["mix", "phx.server"]
