#!/usr/bin/env bash
set -uo pipefail
r=$(kubectl -n starfleet get svc relay -o jsonpath='{.spec.ports[0].port}/{.spec.ports[0].targetPort}' 2>/dev/null)
b=$(kubectl -n starfleet get svc beacon -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$r" = '80/8080' ] && [ "$b" = '80' ]; then echo 'PASS: Service ports kept'; else echo "FAIL: relay=$r beacon=$b"; exit 1; fi
