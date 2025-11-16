#! /bin/bash
set -e
V=${1:-0.5.2}
url="https://github.com/lindig/expr/archive/$V.zip"
test -f $V.zip || wget "$url"
cat <<EOF
url {
  src: "$url"
  checksum: [
    "sha256=$(sha256 -q $V.zip)"
    "md5=$(md5 -q $V.zip)"
  ]
}
EOF
