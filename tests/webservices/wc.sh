#! /bin/bash

id_w=$(eval_ws wc/create "session_id=$id&repo_id=$id_r&name=project1-wc1&manager=default") ; echo $id_w
raw_ws wc/create "session_id=$id&repo_id=$id_r&name=project1-wc2&manager=default"
raw_ws wc/list "session_id=$id"

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
