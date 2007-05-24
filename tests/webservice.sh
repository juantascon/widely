
rm -rf /tmp/repos* /tmp/wc* /tmp/admin*

host="localhost:7777"

exec_test()
{
	eval "val=$(curl $host/api/$1 -d $2 2>/dev/null)"
	echo $val
}


id=$(exec_test auth/login "user_id=admin&password=admin")
echo $id

id_r=$(exec_test repos/create "session_id=$id&manager_id=svn&name=project1")
echo $id_r

id_w=$(exec_test wc/create "session_id=$id&repos_id=$id_r&name=project1-wc1")
echo $id_w



id=$(exec_test auth/login "user_id=admin&password=admin")
echo $id

exec_test auth/set_wc "session_id=$id&wc_id=$id_w"

exec_test wc/checkout "session_id=$id"

exec_test wc/add "session_id=$id&path=/file1"
exec_test wc/write "session_id=$id&path=/file1&content=quemasbien"
exec_test wc/add "session_id=$id&path=/file2"
exec_test wc/write "session_id=$id&path=/file2&content=hola-soy-un-archivo"
exec_test wc/commit "session_id=$id&log=version1"



exec_test wc/add "session_id=$id&path=/dir1&as_dir=true"
exec_test wc/add "session_id=$id&path=/dir1/dir1_1&as_dir=true"
exec_test wc/add "session_id=$id&path=/dir1/dir1_1/file1_1_1"
exec_test wc/write "session_id=$id&path=/dir1/dir1_1/file1_1_1&content=soy-otro-archivo"
exec_test wc/commit "session_id=$id&log=version2"

exec_test wc/ls "session_id=$id&path=/"
exec_test wc/versions "session_id=$id"

