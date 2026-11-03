# Choose A Controller, Class, Paths And Hosts - Playground

- **Slug:** ats-026-playground-050-02
- **Type:** Astrona playground, clean environment, no task, no grading
- **Status:** UNTESTED. Built and checked statically only. It has not been run.

Playground for the module on IngressClass, the default class, path types, hosts and the default backend. It starts Traefik v3.6.1, two IngressClasses (`traefik` and `legacy`), four backends and a `curl` client Pod.

## Run it

```sh
astrona run -c .
astrona destroy ats-026-playground-050-02
```
