#! /bin/bash

(
	cd $(dirname $0)
	for x in functions login repo wc userdata compiler destroy
	do
		. ./$x.sh
	done
)
