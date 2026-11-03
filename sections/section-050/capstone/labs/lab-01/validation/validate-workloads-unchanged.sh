#!/usr/bin/env bash
set -uo pipefail
for name in web api; do
  image=$(kubectl -n starfleet get deploy "$name" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
  if [ "$image" != "nginx:1.31.6-alpine" ]; then echo "FAIL: $name image is '$image'"; exit 1; fi
done
api_port=$(kubectl -n starfleet get service api -o jsonpath='{.spec.ports[0].port}:{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$api_port" != "80:http" ]; then echo "FAIL: the Service api ports are '$api_port', expected 80:http"; exit 1; fi
host=$(kubectl -n starfleet get ingress portal -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
if [ "$host" != "portal.local" ]; then echo "FAIL: the rule host is '$host', expected portal.local"; exit 1; fi
controller=$(kubectl -n ingress-system get deploy traefik -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$controller" != "docker.io/library/traefik:v3.6.1" ]; then echo "FAIL: controller image is '$controller'"; exit 1; fi
echo "PASS: images, the api Service, the rule host and the controller are unchanged"
