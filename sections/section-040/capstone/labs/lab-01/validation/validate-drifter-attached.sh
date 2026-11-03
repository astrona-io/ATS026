#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
conditions=$(kubectl -n outpost get httproute drifter -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status}{"\n"}{end}' 2>/dev/null)
grep -qx 'Accepted=True' <<<"$conditions" || fail "HTTPRoute drifter in outpost is not Accepted (conditions: $conditions)"
grep -qx 'ResolvedRefs=True' <<<"$conditions" || fail "HTTPRoute drifter does not have ResolvedRefs=True (conditions: $conditions)"
body=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: drifter.local' "http://$GATEWAY_ADDRESS/" 2>/dev/null)
grep -q '"message": *"drifter"' <<<"$body" || fail "a request for drifter.local did not reach the drifter Service (got: $body)"
echo "PASS: the route in outpost is accepted and reaches drifter"
