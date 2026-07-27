FROM haskell:9.4 AS build
#########################

ARG MESSAGE=2
ARG STORE=2
ARG STUDIO=18
ARG IDENT=2
ARG DUMB=2
ARG ELM=0.19.1

WORKDIR /srv
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gettext-base \
        git \
        gzip \
        markdown \
        npm \
        rsync \
        uglifyjs \
    && curl -L -o elm.gz https://github.com/elm/compiler/releases/download/$ELM/binary-for-linux-64-bit.gz \
    && gunzip elm.gz \
    && chmod +x elm \
    && mv elm /usr/local/bin/ \
    && cabal update

ADD cabal.project /srv/

ADD https://api.github.com/repos/Modelyz/message/git/refs/tags/$MESSAGE message.json
RUN git clone --depth 1 --branch $MESSAGE https://github.com/Modelyz/message

ADD https://api.github.com/repos/Modelyz/store/git/refs/tags/$STORE store.json
RUN git clone --depth 1 --branch $STORE https://github.com/Modelyz/store

ADD https://api.github.com/repos/Modelyz/studio/git/refs/tags/$STUDIO studio.json
RUN git clone --depth 1 --branch $STUDIO https://github.com/Modelyz/studio

ADD https://api.github.com/repos/Modelyz/ident/git/refs/tags/$IDENT ident.json
RUN git clone --depth 1 --branch $IDENT https://github.com/Modelyz/ident

ADD https://api.github.com/repos/Modelyz/dumb/git/refs/tags/$DUMB dumb.json
RUN git clone --depth 1 --branch $DUMB https://github.com/Modelyz/dumb

RUN cabal build message -O --ghc-options="-Wall" --enable-library-stripping
RUN cabal build studio store ident dumb -O --ghc-options="-Wall" --enable-library-stripping --enable-executable-static
RUN cabal install studio store ident dumb -O --ghc-options="-Wall" --installdir=build

RUN cd studio/front  && ./build.sh -o


FROM debian:bullseye
####################

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext-base

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
