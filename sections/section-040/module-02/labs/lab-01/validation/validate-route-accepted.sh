#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
conditions=$(kubectl -n starfleet get httproute scout -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status}{"\n"}{end}' 2>/dev/null)
grep -qx 'Accepted=True' <<<"$conditions" || fail "HTTPRoute scout is not Accepted (conditions: $conditions)"
grep -qx 'ResolvedRefs=True' <<<"$conditions" || fail "HTTPRoute scout does not have ResolvedRefs=True (conditions: $conditions)"
parent=$(kubectl -n starfleet get httproute scout -o jsonpath='{.spec.parentRefs[0].name}' 2>/dev/null)
[ "$parent" = "edge" ] || fail "HTTPRoute scout must attach to the Gateway edge, found '$parent'"
host=$(kubectl -n starfleet get httproute scout -o jsonpath='{.spec.hostnames[0]}' 2>/dev/null)
[ "$host" = "scout.local" ] || fail "HTTPRoute scout must use the host name scout.local, found '$host'"
echo "PASS: HTTPRoute scout is accepted and its backends resolve"
