#!/usr/bin/env bash
set -uo pipefail
for name in scout probe bridge fallback; do
  image=$(kubectl -n starfleet get deploy "$name" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
  port=$(kubectl -n starfleet get service "$name" -o jsonpath='{.spec.ports[0].port}:{.spec.ports[0].targetPort}' 2>/dev/null)
  if [ "$image" != "nginx:1.31.6-alpine" ] || [ "$port" != "80:http" ]; then
    echo "FAIL: $name image='$image' service='$port'"
    exit 1
  fi
done
controller=$(kubectl -n ingress-system get deploy traefik -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$controller" != "docker.io/library/traefik:v3.6.1" ]; then echo "FAIL: controller image is '$controller'"; exit 1; fi
echo "PASS: backends, Services and the controller are unchanged"
