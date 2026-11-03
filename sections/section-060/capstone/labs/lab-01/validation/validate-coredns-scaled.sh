#!/usr/bin/env bash
set -uo pipefail
desired=$(kubectl -n kube-system get deployment coredns -o jsonpath='{.spec.replicas}')
ready=$(kubectl -n kube-system get deployment coredns -o jsonpath='{.status.readyReplicas}')
updated=$(kubectl -n kube-system get deployment coredns -o jsonpath='{.status.updatedReplicas}')
if [ "${desired:-0}" -ge 3 ] && [ "${ready:-0}" = "$desired" ] && [ "${updated:-0}" = "$desired" ]; then echo "PASS: $ready of $desired CoreDNS replicas are ready"; else echo "FAIL: CoreDNS replicas desired='$desired' ready='${ready:-0}' updated='${updated:-0}', expected at least 3 ready"; exit 1; fi
