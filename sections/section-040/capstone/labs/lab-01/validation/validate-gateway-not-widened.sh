#!/usr/bin/env bash
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
GATEWAY_ADDRESS=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}' 2>/dev/null)
[ -n "$GATEWAY_ADDRESS" ] || fail "the Gateway edge has no address"
from=$(kubectl -n starfleet get gateway edge -o jsonpath='{.spec.listeners[0].allowedRoutes.namespaces.from}' 2>/dev/null)
[ "$from" = "Selector" ] || fail "the Gateway edge must keep allowedRoutes from Selector (found '$from')"
selector=$(kubectl -n starfleet get gateway edge -o jsonpath='{.spec.listeners[0].allowedRoutes.namespaces.selector.matchLabels.gateway-access}' 2>/dev/null)
[ "$selector" = "allowed" ] || fail "the selector of the Gateway edge was changed (found '$selector')"
for name in scout-v1 scout-v2; do
  image=$(kubectl -n starfleet get deploy "$name" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
  [ "$image" = "ghcr.io/stefanprodan/podinfo:6.15.0" ] || fail "$name image changed to '$image'"
done
outpost_label=$(kubectl get namespace outpost -o jsonpath='{.metadata.labels.gateway-access}' 2>/dev/null)
[ "$outpost_label" = "allowed" ] || fail "the namespace outpost must carry gateway-access=allowed"
echo "PASS: the Gateway and the workloads are unchanged"
