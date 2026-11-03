#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
conditions=$(kubectl -n starfleet get httproute scout -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status}{"\n"}{end}' 2>/dev/null)
grep -qx 'Accepted=True' <<<"$conditions" || fail "HTTPRoute scout is not Accepted (conditions: $conditions)"
grep -qx 'ResolvedRefs=True' <<<"$conditions" || fail "HTTPRoute scout does not have ResolvedRefs=True (conditions: $conditions)"
for i in 1 2 3 4 5; do
  body=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: scout.local' -H 'x-canary: true' "http://$GATEWAY_ADDRESS/" 2>/dev/null)
  grep -q '"message": *"v2"' <<<"$body" || fail "a request with x-canary: true did not reach scout-v2 (got: $body)"
done
default=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H 'Host: scout.local' "http://$GATEWAY_ADDRESS/" 2>/dev/null)
grep -Eq '"message": *"v[12]"' <<<"$default" || fail "a request without the header did not reach scout-v1 or scout-v2 (got: $default)"
echo "PASS: the canary header reaches scout-v2 and plain requests are served"
