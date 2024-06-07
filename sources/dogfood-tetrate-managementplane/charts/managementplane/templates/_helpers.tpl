{{/* Postgres config yaml required by postgres secret  */}}
{{- define "secret.postgres.config" -}}
{{- $postgres := required "secrets.postgres" .Values.secrets.postgres -}}
data:
  username: {{ required "secrets.postgres.username" $postgres.username | quote }}
  password: {{ .randomOrProvidedPostgresPassword | quote }}
{{ end }}

{{/* Postgres config yaml required by postgres secret  */}}
{{- define "secret.postgres.pg_service" -}}
{{- $postgres := required "secrets.postgres" .Values.secrets.postgres -}}
[postgres-db]
user={{ required "secrets.postgres.username" $postgres.username }}
password={{ .randomOrProvidedPostgresPassword }}

[postgres-embedded-db]
password={{ .embeddedPassword }}
{{ end }}

{{/*
 XCP central auth mode computation from the given spec.
 It returns a yaml that can be parsed to place it into a var.
 If no spec configuration nor properties are provided it will default to enable only jwt.
*/}}
{{- define "getXCPauthModesYAML" -}}
{{- $spec := default dict .Values.spec }}
{{- $componentsSpec := default dict $spec.components }}
{{- $xcpSpec := default dict $componentsSpec.xcp }}
{{- $xcpAuthMode := default dict $xcpSpec.centralAuthModes }}
jwt: {{ default true $xcpAuthMode.jwt }}
mtls: {{ default false $xcpAuthMode.mutualTls }}
{{- end }}


{{- define "getPostgresPasswordFromSecret" -}}
{{- if hasKey .data "embedded-postgres-password" -}}
{{ index .data "embedded-postgres-password" -}}
{{- else if hasKey .data "config.yaml" -}}
{{ ((index .data "config.yaml" | b64dec | fromYaml).data).password | b64enc }}
{{- end -}}
{{- end }}

{{- define "getElasticSearchPasswordFromSecret" -}}
{{- if hasKey .data "password" -}}
{{ index .data "password" -}}
{{- end -}}
{{- end }}
