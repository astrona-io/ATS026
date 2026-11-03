#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
body=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: scout.local' -H 'x-canary: true' "http://$GATEWAY_ADDRESS/" 2>/dev/null)
grep -q '"message": *"v2"' <<<"$body" || fail "a request with x-canary: true did not return the message v2 (got: $body)"
other=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: scout.local' -H 'x-canary: false' "http://$GATEWAY_ADDRESS/" 2>/dev/null)
grep -q '"message": *"v1"' <<<"$other" || fail "a request with x-canary: false must still reach scout-v1 (got: $other)"
echo "PASS: only x-canary: true reaches scout-v2"
