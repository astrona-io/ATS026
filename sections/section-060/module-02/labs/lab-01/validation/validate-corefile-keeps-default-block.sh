#!/usr/bin/env bash
set -uo pipefail
corefile=$(kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}')
if echo "$corefile" | grep -Eq '^[[:space:]]*kubernetes[[:space:]]+cluster\.local' && echo "$corefile" | grep -Eq '^[[:space:]]*forward[[:space:]]+\.[[:space:]]+/etc/resolv\.conf'; then
  echo "PASS: the default kubernetes and forward directives are present"
else
  echo "FAIL: the Corefile lost the kubernetes or the forward . /etc/resolv.conf directive"; exit 1
fi
