#! /bin/bash

(
	cd $(dirname $0)
	for x in functions login repo wc userdata
	do
		. ./$x.sh
	done
)
