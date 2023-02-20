#!/bin/bash
set -e -o pipefail
echo "# RUNNING: $(dirname $0)/$(basename $0)"

# generate script
script="install-nginx.sh"
cat <<'EOF_SCRIPT' > /home/ubuntu/${script}
#!/bin/bash
set -x -e -o pipefail

function clean() {
    ret=$?
    if [ "$ret" -gt 0 ] ;then
        echo "FAILURE $0: $ret"
    else
        echo "SUCCESS $0: $ret"
    fi
    exit $ret
}

trap clean EXIT QUIT KILL

[ -f /home/ubuntu/config.cfg ] && source /home/ubuntu/config.cfg

cd /home/ubuntu

sudo apt-get update -qy
sudo apt-get install -qy nginx curl

cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80;

    root /usr/share/nginx/html;
    try_files /index.html =404;

    expires -1;

    sub_filter_once off;
    sub_filter 'server_hostname' '$hostname';
    sub_filter 'server_address' '$server_addr:$server_port';
    sub_filter 'server_url' '$request_uri';
    sub_filter 'server_date' '$time_local';
    sub_filter 'request_id' '$request_id';
}
EOF

cat <<'EOF_NGINX' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Hello World</title>

<style>
body {
  margin: 0px;
  font: 20px 'RobotoRegular', Arial, sans-serif;
  font-weight: 100;
  height: 100%;
  color: #0f1419;
}
div.info {
  display: table;
  background: #e8eaec;
  padding: 20px 20px 20px 20px;
  border: 1px dashed black;
  border-radius: 10px;
  margin: 0px auto auto auto;
}
div.info p {
    display: table-row;
    margin: 5px auto auto auto;
}
div.info p span {
    display: table-cell;
    padding: 10px;
}
img {
    width: 176px;
    margin: 36px auto 36px auto;
    display:block;
}
div.smaller p span {
    color: #3D5266;
}
h1, h2 {
  font-weight: 100;
}
div.check {
    padding: 0px 0px 0px 0px;
    display: table;
    margin: 36px auto auto auto;
    font: 12px 'RobotoRegular', Arial, sans-serif;
}
#footer {
    position: fixed;
    bottom: 36px;
    width: 100%;
}
#center {
    width: 400px;
    margin: 0 auto;
    font: 12px Courier;
}
</style>
<script>
var ref;
function checkRefresh(){
    if (document.cookie == "refresh=1") {
        document.getElementById("check").checked = true;
        ref = setTimeout(function(){location.reload();}, 1000);
    } else {
    }
}
function changeCookie() {
    if (document.getElementById("check").checked) {
        document.cookie = "refresh=1";
        ref = setTimeout(function(){location.reload();}, 1000);
    } else {
        document.cookie = "refresh=0";
        clearTimeout(ref);
    }
}
</script>
</head>
<body onload="checkRefresh();">
<img alt="NGINX Logo" src="./nginx.png"/>
<div class="info">
<p><span>Server&nbsp;address:</span> <span>server_address</span></p>
<p><span>Server&nbsp;name:</span> <span>server_hostname</span></p>
<p class="smaller"><span>Date:</span> <span>server_date</span></p>
<p class="smaller"><span>URI:</span> <span>server_url</span></p>
</div>
<div class="check"><input type="checkbox" id="check" onchange="changeCookie()"> Auto Refresh</div>
    <div id="footer">
        <div id="center" align="center">
            Request ID: request_id<br/>
            &copy; NGINX, Inc. 2018
        </div>
    </div>
</body>
</html>
EOF_NGINX
sudo service nginx restart

curl http://localhost -I

EOF_SCRIPT

# run script
echo "# run /home/ubuntu/${script}"
chmod +x /home/ubuntu/${script}
/home/ubuntu/${script}
echo "# end /home/ubuntu/${script}"
