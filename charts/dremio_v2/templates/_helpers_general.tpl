{{/*
Shared - Image Pull Secrets
*/}}
{{- define "dremio.imagePullSecrets" -}}
{{- if $.Values.imagePullSecrets }}
imagePullSecrets:
{{- range $secretName := $.Values.imagePullSecrets }}
- name: {{ $secretName }}
{{- end}}
{{- end -}}
{{- end -}}

{{/*
Service - Annotations
*/}}
{{- define "dremio.service.annotations" -}}
{{- $serviceAnnotations := coalesce $.Values.service.annotations $.Values.annotations -}}
{{- if $.Values.service.internalLoadBalancer }}
annotations:
  service.beta.kubernetes.io/azure-load-balancer-internal: "true"
  cloud.google.com/load-balancer-type: "Internal"
  service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0
  {{- if $serviceAnnotations -}}
  {{- toYaml $serviceAnnotations | nindent 2 -}}
  {{- end -}}
{{- else -}}
{{ if $serviceAnnotations }}
annotations:
  {{- toYaml $serviceAnnotations | nindent 4 -}}
{{- end -}}
{{- end }}
{{- end -}}

{{/*
Service - Labels
*/}}
{{- define "dremio.service.labels" -}}
{{- $serviceLabels := coalesce $.Values.service.labels $.Values.labels -}}
{{- if $serviceLabels -}}
{{- toYaml $serviceLabels }}
{{- end -}}
{{- end -}}

{{/*
Admin - Pod Annotations
*/}}
{{- define "dremio.admin.podAnnotations" -}}
{{- $adminPodAnnotations := coalesce $.Values.coordinator.podAnnotations $.Values.podAnnotations -}}
{{- if $adminPodAnnotations -}}
annotations:
  {{- toYaml $adminPodAnnotations | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
Admin - Pod Labels
*/}}
{{- define "dremio.admin.podLabels" -}}
{{- $adminPodLabels := coalesce $.Values.coordinator.podLabels $.Values.podLabels -}}
{{- if $adminPodLabels -}}
labels:
  {{- toYaml $adminPodLabels | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
Admin - Pod Node Selectors
*/}}
{{- define "dremio.admin.nodeSelector" -}}
{{- $adminNodeSelector := coalesce $.Values.coordinator.nodeSelector $.Values.nodeSelector -}}
{{- if $adminNodeSelector -}}
nodeSelector:
  {{- toYaml $adminNodeSelector | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
Admin - Pod Tolerations
*/}}
{{- define "dremio.admin.tolerations" -}}
{{- $adminPodTolerations := coalesce $.Values.coordinator.tolerations $.Values.tolerations -}}
{{- if $adminPodTolerations -}}
tolerations:
  {{- toYaml $adminPodTolerations | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
Admin - Pod Extra Volumes
*/}}
{{- define "dremio.admin.extraVolumes" -}}
{{- $adminExtraVolumes := coalesce $.Values.admin.extraVolumes $.Values.extraVolumes -}}
{{- if $adminExtraVolumes -}}
{{ toYaml $adminExtraVolumes }}
{{- end -}}
{{- end -}}

{{/*
Admin - Pod Extra Volume Mounts
*/}}
{{- define "dremio.admin.extraVolumeMounts" -}}
{{- $adminExtraVolumeMounts := default (default (dict) $.Values.extraVolumeMounts) $.Values.admin.extraVolumeMounts -}}
{{- if $adminExtraVolumeMounts -}}
{{ toYaml $adminExtraVolumeMounts }}
{{- end -}}
{{- end -}}

{{/*
NAS Distributed Storage Volume
*/}}
{{- define "dremio.distStorage.nas.volume" -}}
{{- if (eq $.Values.distStorage.type "nas") -}}
{{- $nasConfig := $.Values.distStorage.nas -}}
- name: dremio-dist-storage
  persistentVolumeClaim:
    claimName: {{ $nasConfig.claimName }}
{{- end -}}
{{- end -}}

{{/*
NAS Distributed Storage Peristent Volume Mounts
*/}}
{{- define "dremio.distStorage.nas.volumeMounts" -}}
{{- if (eq $.Values.distStorage.type "nas") -}}
- name: dremio-dist-storage
  mountPath: /opt/dremio/dist
{{- end -}}
{{- end -}}

{{/*
Admin - Service Account
*/}}
{{- define "dremio.admin.serviceAccount" -}}
{{- $adminServiceAccount := $.Values.coordinator.serviceAccount -}}
{{- if $adminServiceAccount -}}
serviceAccount: {{ $adminServiceAccount }}
{{- end -}}
{{- end -}}
