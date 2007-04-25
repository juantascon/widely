
rm -rf /tmp/repos* /tmp/wc*

host="localhost:7777"

curl $host/api/repos/create -d "manager=svn&dir=/tmp/repos1"
curl $host/api/wc/create -d "wc_dir=/tmp/wc1&repository_id=0"
curl $host/api/wc/checkout -d "wc_id=0"

curl $host/api/wc/add -d "wc_id=0&path=/file1"
curl $host/api/wc/write -d "wc_id=0&path=/file1&content=quemasbien"
curl $host/api/wc/add -d "wc_id=0&path=/file2"
curl $host/api/wc/write -d "wc_id=0&path=/file2&content=hola-soy-un-archivo"

curl $host/api/wc/add -d "wc_id=0&path=/dir1&as_dir=true"
curl $host/api/wc/add -d "wc_id=0&path=/dir1/dir1_1&as_dir=true"


curl $host/api/wc/add -d "wc_id=0&path=/dir1/dir1_1/file1_1_1"
curl $host/api/wc/write -d "wc_id=0&path=/dir1/dir1_1/file1_1_1&content=soy-otro-archivo"

curl $host/api/wc/commit -d "wc_id=0&log=version1"
curl $host/api/wc/ls -d "wc_id=0&path=/"

