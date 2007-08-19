#! /bin/bash

. ./functions.sh

admin_id=$(obj_ws auth/login_admin "password=admin") ; echo $admin_id
id=$(obj_ws auth/login "user_id=test&password=test") ; echo $id

raw_ws auth/set_wc "session_id=$id&wc_id=project1-wc1"


raw_ws wc/status "session_id=$id"

