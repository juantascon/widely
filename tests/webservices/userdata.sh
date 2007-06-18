#! /bin/bash

raw_ws userdata/set_value "session_id=$id&key=name&value=juandi1"
raw_ws userdata/set_value "session_id=$id&key=name&value=juandi2"
raw_ws userdata/get_value "session_id=$id&key=name"
raw_ws userdata/get_value "session_id=$id&key=invalidkey"
