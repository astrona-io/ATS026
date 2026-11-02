---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Starting Environment

The lab includes a working Traefik Ingress controller and healthy application. The required route has not been created.

Create an Ingress `probe` for class `traefik`, host `probe.local`, Prefix path `/` and backend Service `probe` port 80. The request through the controller with the matching Host header must receive version one. An unmatched host must return 404. Preserve the original application and Service.
