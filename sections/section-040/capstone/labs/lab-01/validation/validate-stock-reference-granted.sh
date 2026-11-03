#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
conditions=$(kubectl -n starfleet get httproute stock -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status}{"\n"}{end}' 2>/dev/null)
grep -qx 'Accepted=True' <<<"$conditions" || fail "HTTPRoute stock is not Accepted (conditions: $conditions)"
grep -qx 'ResolvedRefs=True' <<<"$conditions" || fail "HTTPRoute stock does not have ResolvedRefs=True (conditions: $conditions)"
body=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: stock.local' "http://$GATEWAY_ADDRESS/" 2>/dev/null)
grep -q '"message": *"stock"' <<<"$body" || fail "a request for stock.local did not reach the stock Service (got: $body)"
echo "PASS: the route in starfleet reaches the Service stock in catalog"
