#!/usr/bin/env bash
set -uo pipefail
s=$(kubectl -n starfleet get deploy signal -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
l=$(kubectl -n starfleet get deploy lantern -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
d=$(kubectl -n starfleet get deploy dock -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$s" = 'nginx:1.31.6-alpine' ] && [ "$l" = 'ghcr.io/stefanprodan/podinfo:6.15.0' ] && [ "$d" = 'ghcr.io/stefanprodan/podinfo:6.15.0' ]; then echo 'PASS: images unchanged'; else echo "FAIL: signal=$s lantern=$l dock=$d"; exit 1; fi
