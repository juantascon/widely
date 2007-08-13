#! /bin/bash

DBFILE="$(cd $(dirname $0) && pwd)/radiant-crm.db"

( ! radiant >/dev/null 2>&1 ) && echo "install radiant first" && exit 1

tmpdir=$(mktemp -d)

echo "Creating radiant instance on: $tmpdir ... "

radiant $tmpdir -d sqlite3 >/dev/null 2>&1

ln -s "$DBFILE" "$tmpdir/db/production.sqlite3.db"

( cd "$tmpdir" ; ./script/server -e production )

rm -rf "$tmpdir"

