FROM haskell:9.12.4 AS build
#########################

WORKDIR /srv
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gettext-base \
        gzip \
        markdown \
        npm \
        rsync \
    && npm install -g elm@0.19.2-0 uglify-js \
    && cabal update

COPY cabal.project /srv/
COPY message /srv/message
COPY store /srv/store
COPY ident /srv/ident
COPY dumb /srv/dumb
COPY studio /srv/studio

RUN cabal build all -O --ghc-options="-Wall"
RUN cabal install studio store ident dumb --installdir=build --install-method=copy

RUN cd studio/front && ./build.sh -o


FROM debian:bookworm-slim
####################

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext-base \
        libgmp10 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /srv/studio/data /srv/store/data /srv/ident/data /srv/dumb/data
COPY --from=build /srv/studio/build /srv/studio
COPY --from=build /srv/build/studio /srv/studio/
COPY --from=build /srv/build/store /srv/store/
COPY --from=build /srv/build/ident /srv/ident/
COPY --from=build /srv/build/dumb /srv/dumb/
COPY entrypoint.sh /srv/
WORKDIR /srv/
VOLUME /srv/store/data
VOLUME /srv/studio/data
VOLUME /srv/ident/data
VOLUME /srv/dumb/data
ENTRYPOINT ["/srv/entrypoint.sh"]
