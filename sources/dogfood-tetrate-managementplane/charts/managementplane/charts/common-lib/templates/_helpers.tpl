{{/* Common labels */}}

{{- define "common.labels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- /*
    Semver using build segment (prefixed with +) is not allowed as label value.
    Even if k8s docs tell a semver is allowed, build segment is not:
    https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels
 */}}
app.kubernetes.io/version: "{{ .Chart.AppVersion | replace "+" "-" }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "-" }}"
{{- end -}}

{{/* Management Plane  */}}

{{- define "common.management-plane.operatorLabels" -}}
platform.tsb.tetrate.io/application: tsb-operator-managementplane
platform.tsb.tetrate.io/component: tsb-operator
platform.tsb.tetrate.io/plane: management
{{- end -}}

{{/* Control Plane  */}}

{{- define "common.control-plane.operatorLabels" -}}
platform.tsb.tetrate.io/application: tsb-operator-controlplane
platform.tsb.tetrate.io/component: tsb-operator
platform.tsb.tetrate.io/plane: control
{{- end -}}

{{/* Data Plane */}}

{{- define "common.data-plane.operatorLabels" -}}
platform.tsb.tetrate.io/application: tsb-operator-dataplane
platform.tsb.tetrate.io/component: tsb-operator
platform.tsb.tetrate.io/plane: data
{{- end -}}

{{/* Secrets keep policy */}}
{{- define "common.secrets.keep" -}}
{{- $secrets := .Values.secrets -}}
{{- if $secrets.keep -}}
"helm.sh/resource-policy": "keep"
{{- end -}}
{{- end -}}

{{/* Default operator deployment resources */}}
{{- define "common.management-plane.default.resources" -}}
limits:
  cpu: 200m
  memory: 512Mi
requests:
  cpu: 100m
  memory: 256Mi
{{- end }}

{{/* Default controlplane operator deployment resources */}}
{{- define "common.control-plane.default.resources" -}}
limits:
  cpu: 500m
  memory: 1024Mi
requests:
  cpu: 100m
  memory: 256Mi
{{- end }}

{{/* Default dataplane operator deployment resources */}}
{{- define "common.data-plane.default.resources" -}}
limits:
  cpu: 1500m
  memory: 2048Mi
requests:
  cpu: 100m
  memory: 256Mi
{{- end }}

{{/* Pull secret JSON from user and pass */}}
{{- define "common.dockerAuthJSON" -}}
{{- $userpass := printf "%s:%s" .Values.operator.pullUsername .Values.operator.pullPassword -}}
{"auths":{"{{.Values.image.registry}}":{"auth":"{{ $userpass | b64enc }}"}}}
{{- end }}


{{/* Default liveness and readiness probe for operators */}}
{{- define "livenessProbe" -}}
livenessProbe:
   initialDelaySeconds: 1
   periodSeconds: 5
   tcpSocket:
      port: 9082
{{- end}}

{{- define "readinessProbe" -}}
readinessProbe:
   initialDelaySeconds: 5
   periodSeconds: 5
   httpGet:
      port: 9082
      path: /health
{{- end}}
