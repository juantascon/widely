#! /bin/bash

(
	cd $(dirname $0)
	for x in functions login repo wc userdata destroy
	do
		. ./$x.sh
	done
)
