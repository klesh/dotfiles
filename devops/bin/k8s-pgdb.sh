#!/bin/sh

set -e

if [ "$#" -lt 4 ] ;then
    echo "Backup postgres database on k8s container with pg_dump and gzip"
    echo
    echo "  Usage $0 <path-to-dbname.gz> <pod-app-label> <container-name> [dbname]"
    exit 1
fi

BACKUPGZ=$2
APP=$3
CONTAINER=$4
DBNAME=${5-"$(basename "$BACKUPGZ" .sql.gz)"}

POD=$(kubectl get pod --selector "app=$APP" | tail +2 | awk '{print $1}')
if [ -z "$POD" ] ; then
    echo not pod found!
    exit 1
fi

backup () {
    kubectl exec "$POD" -c "$CONTAINER" -- pg_dump -U postgres --no-owner "$DBNAME" | gzip > "$BACKUPGZ"
}

restore () {
    kubectl exec "$POD" -c "$CONTAINER" -- psql postgres postgres -c "DROP DATABASE IF EXISTS $DBNAME"
    kubectl exec "$POD" -c "$CONTAINER" -- psql postgres postgres -c "CREATE DATABASE  $DBNAME"
    kubectl exec -i "$POD" -c "$CONTAINER" -- sh -c "gunzip -c | psql $DBNAME postgres" < "$BACKUPGZ"
}


case $1 in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
esac
