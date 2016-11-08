FROM takesxisximada/docker-alpine
MAINTAINER TakesxiSximada <@TakesxiSximada>

ARG USER=ng
ARG GROUP=ng
ARG UID=1234
ARG GID=1235

ARG GAURUN_EXE=build/gaurun
ARG GAURUN_RECOVER_EXE=build/gaurun_recover

ENV NG_USER ${USER}
ENV NG_GROUP ${GROUP}
ENV NG_UID ${UID}
ENV NG_GID ${GID}

RUN addgroup -g $NG_GID $NG_GROUP
RUN adduser -H -D -G $NG_GROUP -u $NG_UID $NG_USER

COPY ${GAURUN_EXE} /usr/bin/
COPY ${GAURUN_RECOVER_EXE} /usr/bin/

RUN mkdir -p /gaurun
WORKDIR /gaurun
COPY gaurun.toml ./
COPY docker-entrypoint.sh ./
EXPOSE 1056

ENV VAULT_ADDR http://vault.internal:8200
CMD ["sh" , "docker-entrypoint.sh"]
