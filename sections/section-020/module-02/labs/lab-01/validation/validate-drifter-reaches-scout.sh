#!/usr/bin/env bash
set -uo pipefail
# Retries for a short time because a new policy needs a moment to reach the network plugin.
out=""
for attempt in 1 2 3 4 5; do
  out=$(kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}' http://scout.starfleet.svc/ 2>/dev/null)
  [ "$out" = "200" ] && break
  sleep 2
done
if [ "$out" = "200" ]; then echo "PASS: outpost/drifter reached http://scout.starfleet.svc/"; else echo "FAIL: outpost/drifter did not get HTTP 200 from http://scout.starfleet.svc/ (got '$out')"; exit 1; fi
