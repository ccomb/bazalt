#!/bin/bash
# TODO : l'alias SSH « modelyz » et le chemin serveur services/prelab/modelyz datent de l'ancienne infra — à renommer côté serveur.

if [ "$1" == "--reset" ]; then
    echo "Deleting data"
    RESET="/opt/bin/docker-compose down -v"
elif [ "$1" == "--keep" ]; then
    RESET="echo keeping data"
else
    echo use --reset to delete data or --keep to keep it
    exit 1
fi

# define studio host in .ssh/config
docker tag bazalt rg.fr-par.scw.cloud/prelab/bazalt
docker push rg.fr-par.scw.cloud/prelab/bazalt
ssh modelyz "cd services/prelab/modelyz && $RESET && git pull && /opt/bin/docker-compose pull && /opt/bin/docker-compose up -d"
