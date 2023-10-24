{{/*
Expand the name of the chart.
*/}}
{{- define "segway-sys-router.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "segway-sys-router.fullname" -}}
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
{{- define "segway-sys-router.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "segway-sys-router.labels" -}}
helm.sh/chart: {{ include "segway-sys-router.chart" . }}
{{ include "segway-sys-router.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/component: router
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: segway
{{- end }}

{{/*
Selector labels
*/}}
{{- define "segway-sys-router.selectorLabels" -}}
app.kubernetes.io/name: {{ include "segway-sys-router.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "segway-sys-router.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "segway-sys-router.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use
*/}}
{{- define "segway-sys-router.secretname" -}}
{{- if .Values.secret.create }}
{{- default (include "segway-sys-router.fullname" .) .Values.secret.name }}
{{- else }}
{{- default "default" .Values.secret.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the configmap to use
*/}}
{{- define "segway-sys-router.configmapname" -}}
{{- if .Values.secret.create }}
{{- default (include "segway-sys-router.fullname" .) .Values.secret.name }}
{{- else }}
{{- default "default" .Values.config.name }}
{{- end }}
{{- end }}

