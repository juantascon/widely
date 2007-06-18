#! /bin/bash

host="localhost:7777"

raw_ws()
{
	echo $(curl $host/api/$1 -d $2 2>/dev/null)
}

eval_ws()
{
	eval "val=$(curl $host/api/$1 -d $2 2>/dev/null)"
	echo $val
}
