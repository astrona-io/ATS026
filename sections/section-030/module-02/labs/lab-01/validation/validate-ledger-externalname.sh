#!/usr/bin/env bash
set -uo pipefail
type=$(kubectl -n starfleet get service ledger -o jsonpath='{.spec.type}' 2>/dev/null)
target=$(kubectl -n starfleet get service ledger -o jsonpath='{.spec.externalName}' 2>/dev/null)
if [ "$type" != "ExternalName" ] || [ "$target" != "ledger.outpost.svc.cluster.local" ]; then
  echo "FAIL: ledger must be an ExternalName Service for ledger.outpost.svc.cluster.local (got type='$type' externalName='$target')"
  exit 1
fi
code=$(kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O /dev/null -S http://ledger/ 2>&1 | grep -c 'HTTP/1.1 200')
if [ "$code" -ge 1 ]; then echo "PASS: ledger is an ExternalName Service and http://ledger/ answered 200"; else echo "FAIL: http://ledger/ did not answer 200 from shuttle"; exit 1; fi
