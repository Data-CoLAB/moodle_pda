ARG ARCH=
FROM ${ARCH}erseco/alpine-php-webserver:latest

LABEL maintainer="Carlos Domingues - carlos.domingues@datacolab.pt"

USER root
COPY --chown=nobody rootfs/ /

# crond needs root, so install dcron and cap package and set the capabilities
# on dcron binary https://github.com/inter169/systs/blob/master/alpine/crond/README.md
RUN apk add --no-cache dcron libcap php84-exif php84-pecl-redis php84-pecl-igbinary php84-ldap && \
    chown nobody:nobody /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond

# add a quick-and-dirty hack  to fix https://github.com/erseco/alpine-moodle/issues/26
RUN apk add gnu-libiconv=1.15-r3 --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

USER nobody

# Change MOODLE_XX_STABLE for new versions
ENV MOODLE_URL=https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    SITE_URL=http://localhost \
    DB_TYPE=pgsql \
    DB_HOST=172.16.1.101 \
    DB_PORT=30432 \
    DB_NAME=moodle_pda \
    DB_USER=moodle_pda \
    DB_PASS=change_docker_run \
    DB_PREFIX=mdl_ \
    DB_DBHANDLEOPTIONS=false \
    REDIS_HOST= \
    REVERSEPROXY=false \
    SSLPROXY=false \
    MY_CERTIFICATES=none \
    MOODLE_EMAIL=pda@datacolab.pt \
    MOODLE_LANGUAGE=en \
    MOODLE_SITENAME=Portuguese Data Academy \
    MOODLE_USERNAME=pda \
    MOODLE_PASSWORD=change_docker_run \
    SMTP_HOST=smtp.datacolab.pt \
    SMTP_PORT=465 \
    SMTP_USER=noreply1@datacolab.pt \
    SMTP_PASSWORD=change_docker_run \
    SMTP_PROTOCOL=tls \
    MOODLE_MAIL_NOREPLY_ADDRESS=pda@datacolab.pt \
    MOODLE_MAIL_PREFIX=[PDA-Portuguese Data Academy] \
    AUTO_UPDATE_MOODLE=true \
    DEBUG=false \
    client_max_body_size=500M \
    post_max_size=500M \
    upload_max_filesize=500M \
    max_input_vars=5000

RUN curl --location $MOODLE_URL | tar xz --strip-components=1 -C /var/www/html/

