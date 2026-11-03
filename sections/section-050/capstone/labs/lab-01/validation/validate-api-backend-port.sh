#!/usr/bin/env bash
set -uo pipefail
port=$(kubectl -n starfleet get ingress portal -o jsonpath='{range .spec.rules[*].http.paths[?(@.path=="/api")]}{.backend.service.name}:{.backend.service.port.number}{end}' 2>/dev/null)
service_ports=$(kubectl -n starfleet get service api -o jsonpath='{range .spec.ports[*]}api:{.port}{"\n"}{end}' 2>/dev/null)
if [ -n "$port" ] && printf '%s\n' "$service_ports" | grep -qx "$port"; then
  echo "PASS: the /api path points at $port, a port of the Service api"
else
  echo "FAIL: the /api backend is '$port'; the Service api exposes: $(echo $service_ports)"
  exit 1
fi
