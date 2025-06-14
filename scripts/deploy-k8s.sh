#!/bin/bash

# Script para desplegar en Kubernetes
set -e

echo "☸️ Desplegando en Kubernetes..."

# Crear namespace
echo "📁 Creando namespace..."
kubectl apply -f k8s/namespace.yaml

# Desplegar infraestructura
echo "🗄️ Desplegando infraestructura..."
kubectl apply -f k8s/infrastructure/mongodb.yaml
kubectl apply -f k8s/infrastructure/rabbitmq.yaml

# Esperar a que la infraestructura esté lista
echo "⏳ Esperando a que la infraestructura esté lista..."
kubectl wait --for=condition=ready pod -l app=mongodb -n emergencias --timeout=300s
kubectl wait --for=condition=ready pod -l app=rabbitmq -n emergencias --timeout=300s

# Desplegar microservicios
echo "🚀 Desplegando microservicios..."
kubectl apply -f k8s/ms-incidentes/
kubectl apply -f k8s/api-gateway/

# Esperar a que los microservicios estén listos
echo "⏳ Esperando a que los microservicios estén listos..."
kubectl wait --for=condition=ready pod -l app=ms-incidentes -n emergencias --timeout=300s
kubectl wait --for=condition=ready pod -l app=api-gateway -n emergencias --timeout=300s

echo "✅ Despliegue completado!"
echo "📋 Estado del cluster:"
kubectl get pods -n emergencias
kubectl get services -n emergencias

echo ""
echo "🌐 Para acceder al API Gateway:"
echo "kubectl port-forward service/api-gateway-service 3000:80 -n emergencias"