{{- define "gitops-overrides-test.name" -}}
gitops-overrides-test
{{- end -}}

{{- define "gitops-overrides-test.fullname" -}}
{{- printf "%s" (include "gitops-overrides-test.name" .) -}}
{{- end -}}
