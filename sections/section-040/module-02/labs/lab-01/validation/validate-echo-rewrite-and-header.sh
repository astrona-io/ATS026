#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
body=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: scout.local' "http://$GATEWAY_ADDRESS/echo/probe" 2>/dev/null | tr -d ' \n')
grep -q 'anything/probe' <<<"$body" || fail "the echo backend did not receive the path /anything/probe (got: $body)"
grep -q 'echo/probe' <<<"$body" && fail "the prefix /echo was not replaced"
grep -qi '"x-route":\["scout"\]' <<<"$body" || fail "the echo backend did not receive the header x-route: scout"
echo "PASS: /echo/probe reaches echo as /anything/probe with x-route: scout"
