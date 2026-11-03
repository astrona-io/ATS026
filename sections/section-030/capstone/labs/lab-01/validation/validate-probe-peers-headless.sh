#!/usr/bin/env bash
set -uo pipefail
cluster_ip=$(kubectl -n starfleet get service probe-peers -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
selector=$(kubectl -n starfleet get service probe-peers -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$cluster_ip" != "None" ] || [ "$selector" != "probe" ]; then
  echo "FAIL: probe-peers must have clusterIP None and selector app=probe (got clusterIP='$cluster_ip' selector='$selector')"
  exit 1
fi
expected=$(kubectl -n starfleet get pods -l app=probe -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' 2>/dev/null | sort -u)
answer=$(kubectl -n starfleet exec deploy/shuttle -- nslookup probe-peers.starfleet.svc.cluster.local 2>/dev/null \
  | awk '/^Name:/{found=1} found' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u)
if [ -n "$expected" ] && [ "$expected" = "$answer" ]; then echo "PASS: probe-peers resolves to the Pod addresses"; else echo "FAIL: probe-peers must resolve to the probe Pod addresses"; exit 1; fi
