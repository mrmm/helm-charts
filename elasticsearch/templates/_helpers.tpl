{{/* vim: set filetype=mustache: */}}
{{/*
Set discovery service
*/}}
{{- define "discover_service" -}}
{{- printf "%s-discovery" .Values.Cluster.Name | trunc 24 | quote -}}
{{- end -}}

{{/*
Namespace name
*/}}
{{- define "namespace" -}}
{{- printf "%s-%s" .Values.Cluster.Name .Values.Cluster.Env | trunc 24 | quote -}}
{{- end -}}

{{/*
Node type for Data
*/}}
{{- define "data_node" -}}
{{- .Values.Cluster.NodeType.Data | upper | quote }}
{{- end -}}
{{/*
Data PetSet service name
*/}}
{{- define "data_svc_name" -}}
{{ printf "%s-data-svc" .Values.Cluster.Name  | trunc 24 | quote }}
{{- end -}}
{{/*
Data PetSet name
*/}}
{{- define "data_name" -}}
{{ printf "%s-data" .Values.Cluster.Name  | trunc 24 | quote }}
{{- end -}}

{{/*
Node type for Master
*/}}
{{- define "master_node" -}}
{{- .Values.Cluster.NodeType.Master | upper | quote }}
{{- end -}}
{{/*
Master Deployment name
*/}}
{{- define "master_name" -}}
{{ printf "%s-master" .Values.Cluster.Name  | trunc 24 | quote }}
{{- end -}}

{{/*
Node type for Client
*/}}
{{- define "client_node" -}}
{{- .Values.Cluster.NodeType.Client | upper | quote }}
{{- end -}}
{{/*
Client Deployment name
*/}}
{{- define "client_name" -}}
{{ printf "%s-client" .Values.Cluster.Name  | trunc 24 | quote }}
{{- end -}}
{{/*
Client Service name
*/}}
{{- define "client_svc_name" -}}
{{ printf "%s-svc" .Values.Cluster.Name | trunc 24 | quote }}
{{- end -}}


{{/*
Service account
*/}}
{{- define "service_account" -}}
{{- printf "%s-sa" .Values.Cluster.Name | trunc 24 | quote -}}
{{- end -}}

{{/*
Cluster name
*/}}
{{- define "cluster_name" -}}
{{- printf "%s-%s" .Values.Cluster.Name .Values.Cluster.Env | trunc 24 | quote -}}
{{- end -}}

{{/*
Node Slector
*/}}
{{- define "node_selector" -}}
{{if .Values.NodeSelector.Enabled }}
      nodeSelector:
      {{ toYaml .Values.NodeSelector.Selector | indent 2 }}
{{end}}
{{- end -}}

{{/*
Security context
*/}}
{{- define "security_context" -}}
        securityContext:
          capabilities:
            add:
            - IPC_LOCK
          privileged: {{.Values.Cluster.Privileged}}
{{- end -}}
