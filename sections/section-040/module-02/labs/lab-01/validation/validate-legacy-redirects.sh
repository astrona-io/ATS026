#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
result=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -o /dev/null -w '%{http_code} %{redirect_url}' -H 'Host: scout.local' "http://$GATEWAY_ADDRESS/legacy/page" 2>/dev/null)
code=${result%% *}
location=${result#* }
[ "$code" = "301" ] || fail "/legacy/page returned status '$code', expected 301"
grep -Eq '^https?://[^/]+/$' <<<"$location" || fail "the redirect location is '$location', expected the path /"
echo "PASS: /legacy answers with a 301 redirect to /"
