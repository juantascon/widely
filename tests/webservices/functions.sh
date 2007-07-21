#! /bin/bash

host="localhost:7777"

raw_ws()
{
	curl $host/api/$1 -d $2 2>/dev/null
	echo
}

obj_ws()
{
	raw_ws $*|tr ":{},\"" " " | awk '{print $4}'
}
