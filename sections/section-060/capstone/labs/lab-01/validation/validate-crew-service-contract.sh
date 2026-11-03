#!/usr/bin/env bash
set -uo pipefail
cluster_ip=$(kubectl -n starfleet get service crew -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
port=$(kubectl -n starfleet get service crew -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
replicas=$(kubectl -n starfleet get statefulset crew -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$cluster_ip" != "None" ]; then echo "FAIL: Service crew is not headless (clusterIP '$cluster_ip')"; exit 1; fi
if [ "$port" != "80" ]; then echo "FAIL: Service crew must keep port 80 (got '$port')"; exit 1; fi
if [ "${replicas:-0}" != "2" ]; then echo "FAIL: StatefulSet crew has '${replicas:-0}' ready Pods, expected 2"; exit 1; fi
echo "PASS: crew is headless on port 80 with two ready Pods"
