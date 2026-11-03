#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
weights=$(kubectl -n starfleet get httproute scout -o jsonpath='{range .spec.rules[*].backendRefs[*]}{.name}={.weight}{"\n"}{end}' 2>/dev/null)
grep -qx 'scout-v1=90' <<<"$weights" || fail "scout-v1 must have weight 90 in the default rule (found: $weights)"
grep -qx 'scout-v2=10' <<<"$weights" || fail "scout-v2 must have weight 10 in the default rule (found: $weights)"
echo "PASS: the default rule sends 90 to scout-v1 and 10 to scout-v2"
