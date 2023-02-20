#!/bin/bash
# generated terraform template file
# place here all variables
cat <<'EOF' >/home/ubuntu/config.cfg
%{ if http_proxy  != "" ~}
export http_proxy='${http_proxy}'
export https_proxy='${http_proxy}'
%{ endif ~}
%{ if no_proxy  != "" ~}
export no_proxy='${no_proxy}'
%{ endif ~}
EOF
