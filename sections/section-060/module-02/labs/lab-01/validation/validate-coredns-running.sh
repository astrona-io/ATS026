#!/usr/bin/env bash
set -uo pipefail
desired=$(kubectl -n kube-system get deployment coredns -o jsonpath='{.spec.replicas}')
ready=$(kubectl -n kube-system get deployment coredns -o jsonpath='{.status.readyReplicas}')
updated=$(kubectl -n kube-system get deployment coredns -o jsonpath='{.status.updatedReplicas}')
if [ -n "$desired" ] && [ "${ready:-0}" = "$desired" ] && [ "${updated:-0}" = "$desired" ]; then echo "PASS: $ready of $desired CoreDNS replicas are ready"; else echo "FAIL: CoreDNS replicas ready='${ready:-0}' updated='${updated:-0}' desired='$desired'"; exit 1; fi
