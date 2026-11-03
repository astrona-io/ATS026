#!/usr/bin/env bash
set -uo pipefail
ip=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}')
out=$(kubectl -n starfleet exec deploy/shuttle -- nslookup probe.starfleet.svc.cluster.local 2>&1)
if [ -n "$ip" ] && echo "$out" | grep -q "$ip"; then echo "PASS: probe.starfleet.svc.cluster.local resolved to $ip"; else echo "FAIL: the cluster name did not resolve to the Service ClusterIP '$ip'"; exit 1; fi
