#! /bin/bash

set -e

function copyright
{
  ed -s "$1" << 'EOF'
0a
(* SPDX-FileCopyrightText: 2025 Christian Lindig <lindig@gmail.com>
 * SPDX-License-Identifier: Unlicense
 *)
.
w
q
EOF
}

for f in $@; do
  copyright "$f"
done
