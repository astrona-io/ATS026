#!/usr/bin/env bash
set -uo pipefail
ip=$(kubectl -n starfleet get service bridge -o jsonpath='{.spec.clusterIP}')
out=$(kubectl -n starfleet exec deploy/shuttle -- nslookup deck.fleet.internal. 2>&1)
if [ -n "$ip" ] && echo "$out" | grep -q "$ip"; then echo "PASS: deck.fleet.internal resolved to $ip"; else echo "FAIL: deck.fleet.internal did not resolve to the bridge ClusterIP '$ip'"; echo "$out" | tail -5; exit 1; fi
