#!/bin/sh

set -e

if [ "$#" -lt 4 ] ;then
    echo "Backup all postgres databases on k8s container with pg_dump and gzip"
    echo
    echo "  Usage $0 <path-to-backup-directory> <pod-app-label> <container-name> [dbname]"
    exit 1
fi

DIR=$(dirname "$(readlink -f "$0")")
BACKUPDIR=$2
APP=$3
CONTAINER=$4

POD=$(kubectl get pod --selector "app=$APP" | tail +2 | awk '{print $1}')
if [ -z "$POD" ] ; then
    echo not pod found!
    exit 1
fi

backup () {
    mkdir -p "$BACKUPDIR"
    for DBNAME in $(
        kubectl exec "$POD" -c "$CONTAINER" -- \
            psql postgres postgres -c "SELECT datname FROM pg_database" | \
        tail +3 | head -n -2
    ); do
        case $DBNAME in
            postgres|template0|template1)
                ;;
            *)
                echo "backing up $DBNAME to $BACKUPDIR/$DBNAME.sql.gz"
                "$DIR/k8s-pgdb.sh" backup "$BACKUPDIR/$DBNAME.sql.gz" "$APP" "$CONTAINER" "$DBNAME"
                ;;
        esac
    done
}

restore () {
    for BACKUPGZ in "$BACKUPDIR"/*.sql.gz ;do
        "$DIR/pgdb.sh" restore "$BACKUPGZ"
    done
}


case $1 in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
esac
