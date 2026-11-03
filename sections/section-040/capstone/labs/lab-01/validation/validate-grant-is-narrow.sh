#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
count=$(kubectl -n catalog get referencegrant -o name 2>/dev/null | wc -l | tr -d ' ')
[ "$count" -ge 1 ] || fail "no ReferenceGrant exists in the namespace catalog"
froms=$(kubectl -n catalog get referencegrant -o jsonpath='{range .items[*].spec.from[*]}{.kind}/{.namespace}{"\n"}{end}' 2>/dev/null | sort -u)
[ "$froms" = "HTTPRoute/starfleet" ] || fail "the grant must allow only HTTPRoute objects from starfleet (found: $froms)"
tos=$(kubectl -n catalog get referencegrant -o jsonpath='{range .items[*].spec.to[*]}{.kind}/{.name}{"\n"}{end}' 2>/dev/null | sort -u)
[ "$tos" = "Service/stock" ] || fail "the grant must name the Service stock and nothing else (found: $tos)"
label=$(kubectl get namespace catalog -o jsonpath='{.metadata.labels.gateway-access}' 2>/dev/null)
[ -z "$label" ] || fail "the namespace catalog must not get the gateway-access label"
echo "PASS: the grant covers only the Service stock for routes in starfleet"
