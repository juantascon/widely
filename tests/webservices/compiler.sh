#! /bin/bash

bueno="public%20class%20Bueno%0A%7B%0A%09public%20static%20void%20main%20(String%20args[])%0A%09%7B%0A%09%09System.exit(1);%0A%09%7D%0A%7D%0A%0A"

malo="public%20class%20Malo%0A%7B%0A%09public%20static%20void%20main%20(String%20args[])%0A%09%7B%0A%09%09linea%20mala;%0A%09%09System.exit(1);%0A%09%7D%0A%7D%0A%0A"

raw_ws wc/add "session_id=$id&path=/Bueno.java"
raw_ws wc/add "session_id=$id&path=/Malo.java"


raw_ws wc/write "session_id=$id&path=/Bueno.java&content=$bueno"
raw_ws wc/write "session_id=$id&path=/Malo.java&content=$malo"

raw_ws compiler/compile "session_id=$id&manager=javac&path=/Bueno.java"
raw_ws compiler/compile "session_id=$id&manager=javac&path=/Malo.java"
raw_ws compiler/compile "session_id=$id&manager=javac&path=/Noexiste.java"

