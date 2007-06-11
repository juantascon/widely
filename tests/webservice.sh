
rm -rf /tmp/widely

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

id=$(eval_ws auth/login "user_id=test&password=test") ; echo $id

id_r=$(eval_ws repos/create "session_id=$id&name=project1&manager=svn") ; echo $id_r
raw_ws repos/create "session_id=$id&name=project2&manager=svn"
raw_ws repos/list "session_id=$id"

id_w=$(eval_ws wc/create "session_id=$id&repos_id=$id_r&name=project1-wc1&manager=default") ; echo $id_w
raw_ws wc/create "session_id=$id&repos_id=$id_r&name=project1-wc2&manager=default"
raw_ws wc/list "session_id=$id"

admin_id=$(eval_ws auth/login_admin "password=admin") ; echo $admin_id
id=$(eval_ws auth/user_session "session_id=$admin_id&user_id=test") ; echo $id
raw_ws auth/set_wc "session_id=$id&wc_id=$id_w"
raw_ws wc/checkout "session_id=$id"


raw_ws wc/add "session_id=$id&path=/file1"
raw_ws wc/write "session_id=$id&path=/file1&content=quemasbien"
raw_ws wc/add "session_id=$id&path=/file2"
raw_ws wc/write "session_id=$id&path=/file2&content=hola-soy-un-archivo"
raw_ws wc/commit "session_id=$id&log=version1"


raw_ws wc/add "session_id=$id&path=/dir1&as_dir=true"
raw_ws wc/add "session_id=$id&path=/dir1/dir1_1&as_dir=true"
raw_ws wc/add "session_id=$id&path=/dir1/dir1_1/file1_1_1"
raw_ws wc/write "session_id=$id&path=/dir1/dir1_1/file1_1_1&content=soy-otro-archivo"
raw_ws wc/commit "session_id=$id&log=version2"


raw_ws wc/ls "session_id=$id&path=/"
raw_ws wc/versions "session_id=$id"


raw_ws userdata/set_value "session_id=$id&key=name&value=juandi1"
raw_ws userdata/set_value "session_id=$id&key=name&value=juandi2"
raw_ws userdata/get_value "session_id=$id&key=name"
raw_ws userdata/get_value "session_id=$id&key=invalidkey"
