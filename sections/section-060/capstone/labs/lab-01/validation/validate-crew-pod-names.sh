#!/usr/bin/env bash
set -uo pipefail
for pod in crew-0 crew-1; do
  ip=$(kubectl -n starfleet get pod "$pod" -o jsonpath='{.status.podIP}')
  out=$(kubectl -n starfleet exec deploy/shuttle -- nslookup "$pod.crew.starfleet.svc.cluster.local" 2>&1)
  if [ -z "$ip" ] || ! echo "$out" | grep -q "$ip"; then echo "FAIL: $pod.crew.starfleet.svc.cluster.local did not resolve to the Pod IP '$ip'"; exit 1; fi
done
echo "PASS: crew-0 and crew-1 resolve to their Pod IPs"
