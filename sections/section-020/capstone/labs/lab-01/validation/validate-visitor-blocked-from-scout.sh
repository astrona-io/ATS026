#!/usr/bin/env bash
set -uo pipefail
# Retries for a short time because a new policy needs a moment to reach the network plugin.
out=""
for attempt in 1 2 3 4 5; do
  out=$(kubectl -n depot exec deploy/visitor -- curl -s --max-time 3 -o /dev/null -w '%{http_code}' http://scout.starfleet.svc/ 2>/dev/null)
  [ -n "$out" ] && [ "$out" != "200" ] && break
  sleep 2
done
# An empty result means the request could not be sent at all, which does not prove a block.
if [ -n "$out" ] && [ "$out" != "200" ]; then echo "PASS: depot/visitor is blocked from http://scout.starfleet.svc/ (got '$out')"; else echo "FAIL: depot/visitor is not blocked from http://scout.starfleet.svc/ (got '$out')"; exit 1; fi
