
rm -rf /tmp/repos* /tmp/wc*

host="localhost:7777"

curl $host/api/repos/create -d "manager=svn&dir=/tmp/repos1"
curl $host/api/wc/create -d "wc_dir=/tmp/wc1&repository_id=0"
curl $host/api/wc/checkout -d "wc_id=0"

curl $host/api/wc/add -d "wc_id=0&path=/file1"
curl $host/api/wc/write -d "wc_id=0&path=/file1&content=quemasbien"
curl $host/api/wc/commit -d "wc_id=0&log=version1"
curl $host/api/wc/ls -d "wc_id=0&path=/"

