#!/usr/bin/env bash
set -uo pipefail
r=$(kubectl -n starfleet get deploy relay -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
b=$(kubectl -n starfleet get deploy beacon -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$r" = 'nginx:1.31.6-alpine' ] && [ "$b" = 'ghcr.io/stefanprodan/podinfo:6.15.0' ]; then echo 'PASS: images unchanged'; else echo "FAIL: relay=$r beacon=$b"; exit 1; fi
