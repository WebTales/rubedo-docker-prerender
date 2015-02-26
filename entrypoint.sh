#!/bin/bash
set -e

if [ ! -z "${USERNAME}" ] && [ ! -z "${PWDSUPERVISOR}" ]
then
    sed -i 's#username = Username#username = '"$USERNAME"'#g' /etc/supervisord.conf
    sed -i 's#password = PwdSupervisor#password = '"$PWDSUPERVISOR"'#g' /etc/supervisord.conf
fi

exec "$@"