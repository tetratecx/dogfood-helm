{{/*
Expand the name of the chart.
*/}}
{{- define "dynabank.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "dynabank.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dynabank.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dynabank.labels" -}}
helm.sh/chart: {{ include "dynabank.chart" . }}
{{ include "dynabank.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.environment | default "development" }}
{{- with .Values.global.labels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dynabank.selectorLabels" -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dynabank.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dynabank.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common resource requirements
*/}}
{{- define "dynabank.resources" -}}
{{- if .resources }}
{{- toYaml .resources }}
{{- else }}
{{- toYaml .Values.global.resources }}
{{- end }}
{{- end }}

{{/*
Container image reference
*/}}
{{- define "dynabank.image" -}}
{{- if .image.repository }}
{{- if .image.tag }}
{{- printf "%s:%s" .image.repository .image.tag }}
{{- else }}
{{- printf "%s:latest" .image.repository }}
{{- end }}
{{- else }}
{{- printf "%s/%s:%s" .Values.global.imageRegistry .name (.image.tag | default "latest") }}
{{- end }}
{{- end }}

{{/*
Security context
*/}}
{{- define "dynabank.securityContext" -}}
{{- if .securityContext }}
{{- toYaml .securityContext }}
{{- else if .Values.security.podSecurityStandards.enabled }}
runAsNonRoot: true
runAsUser: 1000
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
capabilities:
  drop:
  - ALL
{{- end }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "dynabank.namespace" -}}
{{- .Release.Namespace }}
{{- end }}