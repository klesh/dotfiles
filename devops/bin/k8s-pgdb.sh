#!/bin/sh

set -e

if [ "$#" -lt 3 ] ;then
    echo "Backup/Restore postgres database on k8s"
    echo
    echo "  Usage $0 <backup|restore> <path/to/dbname.sql.gz> <pod-app-label> [container] [dbname]"
    exit 1
fi

GZP=$2
APP=$3
CTN=$4
DBN=${5-"$(basename "$GZP" .sql.gz)"}
POD=$(kubectl get pod --selector "app=$APP" | tail +2 | head -n 1 | awk '{print $1}')

if [ -z "$POD" ] ; then
    echo not pod found!
    exit 1
elif [ "$(echo "$POD" | wc -w)" -gt 1 ] ;then
    echo more than one pod!
    exit 1
fi

backup () {
    kubectl exec "$POD" -c "$CTN" -- sh -c "pg_dump -U postgres --no-owner $DBN | gzip" > "$GZP"
}

restore () {
    kubectl exec "$POD" -c "$CTN" -- psql postgres postgres -c "DROP DATABASE IF EXISTS $DBN"
    kubectl exec "$POD" -c "$CTN" -- psql postgres postgres -c "CREATE DATABASE  $DBN"
    kubectl exec "$POD" -c "$CTN" -i -- sh -c "gunzip -c | psql $DBN postgres" < "$GZP"
}


case $1 in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
esac
