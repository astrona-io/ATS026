#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
body=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: scout.local' "http://$GATEWAY_ADDRESS/" 2>/dev/null)
grep -q '"message": *"v1"' <<<"$body" || fail "a plain request did not return the message v1 (got: $body)"
echo "PASS: a plain request reaches scout-v1"
