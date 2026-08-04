# Multi-source Helm + `ref: values` example

This folder supports the Argo CD / Harness GitOps **values reference** pattern: a Helm chart
from a chart repo plus value files from this git repository.

## Layout

```
custom-apps/values-ref-nginx/
├── helm-values/
│   └── nginx-values.yaml
├── example-multisource-application.yaml
└── README.md
```

Because this repo is `argocd-example-apps` (not a values-only repo), `$values/...` paths are
**relative to the git repo root**. Use:

`$values/custom-apps/values-ref-nginx/helm-values/nginx-values.yaml`

## How it works

| Source index | Argo type | Spec |
|--------------|-----------|------|
| 0 | Directory | This git repo, `ref: values` |
| 1 | Helm | Bitnami `nginx`, valueFiles point at source 0 |

## Harness GitOps — create application

```yaml
sources:
  - repoURL: https://github.com/Him7n/argocd-example-apps.git
    targetRevision: HEAD
    ref: values
  - repoURL: https://charts.bitnami.com/bitnami
    chart: nginx
    targetRevision: "18.2.2"
    helm:
      valueFiles:
        - $values/custom-apps/values-ref-nginx/helm-values/nginx-values.yaml
```

Params: `agent_id`, `cluster_identifier`, `skip_repo_validation: true` (or register repos).

See `example-multisource-application.yaml` for the full Application manifest.

## Update GitOps App step

Include **both** sources in pipeline `sources[]` when updating (list replacement).

## Note vs Harness automation

Automation uses `gitops-automation.git` with `helm-values/` at repo root (`$values/helm-values/...`).
Here values live under `custom-apps/values-ref-nginx/`, so the `$values` path includes that prefix.
