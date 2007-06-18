#! /bin/bash

id=$(eval_ws auth/login "user_id=test&password=test") ; echo $id

admin_id=$(eval_ws auth/login_admin "password=admin") ; echo $admin_id

id=$(eval_ws auth/user_session "session_id=$admin_id&user_id=test") ; echo $id
