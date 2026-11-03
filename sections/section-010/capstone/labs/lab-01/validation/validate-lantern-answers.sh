#!/usr/bin/env bash
set -uo pipefail
out=$(kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}' http://lantern.starfleet.svc/ 2>/dev/null)
if [ "$out" = "200" ]; then echo "PASS: http://lantern.starfleet.svc/ answered 200 from outpost"; else echo "FAIL: http://lantern.starfleet.svc/ did not answer 200 from outpost (got '$out')"; exit 1; fi
