#!/usr/bin/env bash
set -uo pipefail
expected=$(kubectl -n starfleet get pods -l app=probe -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' 2>/dev/null | sort -u)
answer=$(kubectl -n starfleet exec deploy/shuttle -- nslookup probe-pods.starfleet.svc.cluster.local 2>/dev/null \
  | awk '/^Name:/{found=1} found' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u)
if [ -n "$expected" ] && [ "$expected" = "$answer" ]; then
  echo "PASS: probe-pods resolves to the Pod addresses of probe"
else
  echo "FAIL: probe-pods must resolve to exactly the probe Pod addresses (Pods: $(echo $expected) DNS: $(echo $answer))"
  exit 1
fi
