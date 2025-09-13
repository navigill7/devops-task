{{- define "nodejs-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "nodejs-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}
