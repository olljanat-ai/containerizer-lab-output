{{/* Component name. */}}
{{- define "containerizer-app.name" -}}
{{- default .Release.Name .Values.nameOverride -}}
{{- end -}}

{{/* Application the component belongs to. */}}
{{- define "containerizer-app.partOf" -}}
{{- default .Release.Namespace .Values.partOf -}}
{{- end -}}

{{/* Labels on every object; also the selector, so never add to them on a live release. */}}
{{- define "containerizer-app.labels" -}}
app.kubernetes.io/name: {{ include "containerizer-app.name" . }}
app.kubernetes.io/part-of: {{ include "containerizer-app.partOf" . }}
{{- end -}}

{{/* Pod template shared by the Deployment and the CronJob. */}}
{{- define "containerizer-app.podTemplate" -}}
metadata:
  {{- with .Values.podAnnotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "containerizer-app.labels" . | nindent 4 }}
spec:
  securityContext:
    {{- toYaml .Values.podSecurityContext | nindent 4 }}
  automountServiceAccountToken: false
  containers:
  - name: {{ include "containerizer-app.name" . }}
    image: {{ required "image.repository is required" .Values.image.repository }}:{{ required "image.tag is required" .Values.image.tag }}
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- with .Values.env }}
    env:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
    resources:
      {{- toYaml .Values.resources | nindent 6 }}
    {{- with .Values.volumes }}
    volumeMounts:
    {{- range . }}
    - name: {{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .readOnly }}
      readOnly: true
      {{- end }}
    {{- end }}
    {{- end }}
    {{- if .Values.port }}
    ports:
    - name: http
      containerPort: {{ .Values.port }}
    {{- $handler := dict "tcpSocket" (dict "port" "http") }}
    {{- if eq .Values.probe.type "httpGet" }}
    {{- $handler = dict "httpGet" (dict "path" .Values.probe.path "port" "http") }}
    {{- end }}
    readinessProbe:
      {{- toYaml $handler | nindent 6 }}
      {{- toYaml .Values.probe.readiness | nindent 6 }}
    livenessProbe:
      {{- toYaml $handler | nindent 6 }}
      {{- toYaml .Values.probe.liveness | nindent 6 }}
    startupProbe:
      {{- toYaml $handler | nindent 6 }}
      {{- toYaml .Values.probe.startup | nindent 6 }}
    {{- end }}
  {{- with .Values.volumes }}
  volumes:
  {{- range . }}
  - name: {{ .name }}
    {{- if .emptyDir }}
    emptyDir:
      {{- toYaml .emptyDir | nindent 6 }}
    {{- else if .secret }}
    secret:
      {{- toYaml .secret | nindent 6 }}
    {{- else if .persistentVolumeClaim }}
    persistentVolumeClaim:
      claimName: {{ include "containerizer-app.name" $ }}-{{ .name }}
    {{- else }}
    {{- fail (printf "volume %s needs emptyDir, secret or persistentVolumeClaim" .name) }}
    {{- end }}
  {{- end }}
  {{- end }}
  {{- if eq .Values.kind "CronJob" }}
  restartPolicy: {{ .Values.cronJob.restartPolicy }}
  {{- end }}
  enableServiceLinks: false
  serviceAccountName: {{ include "containerizer-app.name" . }}
{{- end -}}
