#!/usr/bin/env bash
set -uo pipefail
out=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}' http://beacon.starfleet.svc/ 2>/dev/null)
if [ "$out" = "200" ]; then echo "PASS: http://beacon.starfleet.svc/ answered 200"; else echo "FAIL: http://beacon.starfleet.svc/ did not answer 200 (got '$out')"; exit 1; fi
