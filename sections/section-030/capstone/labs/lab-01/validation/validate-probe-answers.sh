#!/usr/bin/env bash
set -uo pipefail
status=$(kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O /dev/null -S http://probe/ 2>&1 | grep -c 'HTTP/1.1 200')
if [ "$status" -ge 1 ]; then echo "PASS: http://probe/ answered 200"; else echo "FAIL: http://probe/ did not answer 200 from shuttle"; exit 1; fi
