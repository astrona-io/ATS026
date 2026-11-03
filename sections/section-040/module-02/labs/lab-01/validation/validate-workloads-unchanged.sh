#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
for name in scout-v1 scout-v2; do
  image=$(kubectl -n starfleet get deploy "$name" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
  [ "$image" = "ghcr.io/stefanprodan/podinfo:6.15.0" ] || fail "$name image changed to '$image'"
done
image=$(kubectl -n starfleet get deploy echo -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$image" = "mccutchen/go-httpbin:2.25.0" ] || fail "echo image changed to '$image'"
listener=$(kubectl -n starfleet get gateway edge -o jsonpath='{.spec.listeners[0].allowedRoutes.namespaces.from}' 2>/dev/null)
[ "$listener" = "Same" ] || fail "the Gateway edge was changed (allowedRoutes from '$listener')"
echo "PASS: workloads and Gateway unchanged"
