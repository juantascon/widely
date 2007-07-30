#! /bin/bash


admin_id=$(obj_ws auth/login_admin "password=admin") ; echo $admin_id
raw_ws user/create "session_id=$admin_id&user_id=test&password=test"

raw_ws auth/change_password "session_id=$admin_id&password_old=admin&password_new=admin1"
admin_id=$(obj_ws auth/login_admin "password=admin1") ; echo $admin_id

id=$(obj_ws auth/login "user_id=test&password=test") ; echo $id
raw_ws auth/change_password "session_id=$id&password_old=test&password_new=test1"
id=$(obj_ws auth/login "user_id=test&password=test1") ; echo $id
raw_ws auth/change_password "session_id=$id&password_old=test1&password_new=test"

id=$(obj_ws auth/user_session "session_id=$admin_id&user_id=test") ; echo $id
