#!/bin/bash

set -e

# Create the namespace first
echo "📁 Creating 'monitoring' namespace..."
kubectl create namespace monitoring || echo "Namespace 'monitoring' already exists."

# Add Helm repos
echo "🚀 Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus
echo "📦 Installing Prometheus stack..."
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring

# Wait for Prometheus pods
echo "⏳ Waiting for Prometheus pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n monitoring --timeout=300s

# Patch Prometheus service
echo "🌐 Exposing Prometheus as LoadBalancer..."
kubectl patch svc prometheus-kube-prometheus-prometheus -n monitoring \
  -p '{"spec": {"type": "LoadBalancer"}}'

kubectl get svc -n monitoring

# Install Grafana
echo "📦 Installing Grafana..."
helm install grafana grafana/grafana --namespace monitoring

# Wait for Grafana pods
echo "⏳ Waiting for Grafana pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n monitoring --timeout=300s

# Patch Grafana service
echo "🌐 Exposing Grafana as LoadBalancer..."
kubectl patch svc grafana -n monitoring \
  -p '{"spec": {"type": "LoadBalancer"}}'

kubectl get svc -n monitoring

# Get Grafana password
echo "🔐 Retrieving Grafana admin password..."
GRAFANA_PASSWORD=$(kubectl get secret --namespace monitoring grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode)

echo "✅ Grafana Admin Password: $GRAFANA_PASSWORD"
