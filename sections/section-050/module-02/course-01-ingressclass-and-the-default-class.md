---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# IngressClass And The Default Class

A cluster can run several Ingress controllers, for example one for public traffic and one for internal traffic. Each Ingress must reach the right controller, and the other controllers must leave it alone. Kubernetes solves this with the IngressClass resource and the `ingressClassName` field. This chapter shows how the pieces connect and what the default class changes.

## Controller and class are two objects

An Ingress controller is a program that runs in the cluster, for example as a Deployment. It watches Ingress, Service and EndpointSlice objects through the Kubernetes API and configures its proxy. Traefik is a controller. The proxy is the part that accepts client connections and forwards them.

An IngressClass is a cluster-scoped API object that names a kind of controller. Its field `spec.controller` holds a string, for example `traefik.io/ingress-controller`. The controller program reads the IngressClass objects and handles the Ingresses that select a class whose `spec.controller` string it owns. The string is a naming contract between the object and the program. Kubernetes itself does not start or stop controllers.

An Ingress selects a class with `spec.ingressClassName`. The value is the name of an IngressClass, not the controller string. An Ingress with the name of a class that no running controller owns stays valid for the API server. Nothing handles it, and no error appears. The older annotation `kubernetes.io/ingress.class` did the same job before the field existed. Controllers still read it, but the field is the supported way.

## The default class

Writing the class in every Ingress is easy to forget. A cluster administrator can mark one IngressClass as the default with the annotation `ingressclass.kubernetes.io/is-default-class: "true"`. The API server then runs a step at creation time: when a new Ingress has no `ingressClassName`, the API server writes the name of the default class into the field.

Three facts follow from this mechanism. The class is written once, when the Ingress is created. An Ingress created before the annotation existed keeps an empty class, and marking a class as the default later does not change it. The stored object shows the class, so `kubectl get ingress` and `-o yaml` show what the API server assigned. And two default classes are an error: the API server then refuses to create any Ingress that has no class.

Some controllers also handle Ingresses that have no class at all. That behavior belongs to the controller and its start options, not to the Ingress API. The Kubernetes project recommends defining a default class even then.

## Choosing a controller

Choose a controller from the features that the cluster needs: the supported protocols, TLS handling, the way it gets an address, how it is installed and whether the project is maintained. This course uses Traefik because one manifest installs it in kind without extra tools.

ingress-nginx is another widely used controller. The Kubernetes project announced its retirement for March 2026, with no releases or security fixes after that date. Check the status of any controller before you choose it for a new cluster. The Ingress API itself is frozen and no longer receives new features. New features appear in the Gateway API instead, while Ingress objects keep working.

## Try it: the default class

The next steps show the class selection in the playground. First list the classes and read which controller each one names:

<!-- astrona:playground:renew -->

```sh
kubectl get ingressclass
```

The output has two rows, `traefik` and `legacy`, and the `CONTROLLER` column shows the strings `traefik.io/ingress-controller` and `example.com/legacy-ingress-controller`. No controller owns the second string, so an Ingress of the class `legacy` is never handled.

Save this as `ingress-early.yaml`. It has no class, and no default class exists yet:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: early
  namespace: starfleet
spec:
  rules:
  - host: early.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: scout
            port:
              number: 80
```

Apply it:

```sh
kubectl apply -f ingress-early.yaml
```

Now mark `traefik` as the default class:

```sh
kubectl annotate ingressclass traefik ingressclass.kubernetes.io/is-default-class=true
```

Save this as `ingress-late.yaml`. It also has no class, but it is created after the annotation:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: late
  namespace: starfleet
spec:
  rules:
  - host: late.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: scout
            port:
              number: 80
```

Apply it and compare the two Ingresses:

```sh
kubectl apply -f ingress-late.yaml
kubectl -n starfleet get ingress
```

The `CLASS` column shows `<none>` for `early` and `traefik` for `late`. The API server assigned the class when it created `late`, and it did not change `early`. Request both hosts through the controller and compare the answers. Whether the controller handles the Ingress with no class depends on how it started, and this Traefik instance starts with the option `--providers.kubernetesingress.ingressclass=traefik`:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H 'Host: late.local' http://traefik.ingress-system.svc/
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H 'Host: early.local' http://traefik.ingress-system.svc/
```

The first answer comes from `scout`. To repair `early`, delete it and create it again, or set the class with `kubectl patch`. The default class never repairs an existing Ingress.

The class is now clear, but a class only gets a request to the right controller. What the controller does with the host and the path of that request is the next question.

## Common pitfalls

> [!WARNING]
> An Ingress with a class name that no controller owns is valid and silent. A default class applies only to Ingresses created after the annotation, and two default classes block the creation of Ingresses without a class. Do not copy annotations from one controller to another: each controller reads only its own.
