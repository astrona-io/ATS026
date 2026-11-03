#!/usr/bin/env bash
set -uo pipefail
s=$(kubectl -n starfleet get svc signal -o jsonpath='{.spec.ports[0].port}/{.spec.ports[0].targetPort}' 2>/dev/null)
l=$(kubectl -n starfleet get svc lantern -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
d=$(kubectl -n starfleet get svc dock -o jsonpath='{.spec.ports[0].port}/{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$s" = '80/8080' ] && [ "$l" = '80' ] && [ "$d" = '80/9898' ]; then echo 'PASS: Service ports kept'; else echo "FAIL: signal=$s lantern=$l dock=$d"; exit 1; fi
