#! /bin/bash

id_r=$(eval_ws repo/create "session_id=$id&name=project1&manager=svn") ; echo $id_r
raw_ws repo/create "session_id=$id&name=project2&manager=svn"
raw_ws repo/list "session_id=$id"
