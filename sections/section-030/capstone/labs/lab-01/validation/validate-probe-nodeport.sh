#!/usr/bin/env bash
set -uo pipefail
type=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.type}' 2>/dev/null)
node_port=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
port=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$type" != "NodePort" ] || [ "$node_port" != "30090" ] || [ "$port" != "80" ]; then
  echo "FAIL: probe must be a NodePort Service with port 80 and nodePort 30090 (got type='$type' port='$port' nodePort='$node_port')"
  exit 1
fi
addresses=$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}' 2>/dev/null)
[ -n "$addresses" ] || { echo "FAIL: no node addresses found"; exit 1; }
for address in $addresses; do
  hits=$(kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O /dev/null -S "http://$address:30090/" 2>&1 | grep -c 'HTTP/1.1 200')
  if [ "$hits" -lt 1 ]; then echo "FAIL: http://$address:30090/ did not answer 200"; exit 1; fi
done
echo "PASS: probe answers on port 30090 of every node address"
