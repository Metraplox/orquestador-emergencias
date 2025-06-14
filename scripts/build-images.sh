#!/bin/bash

# Script para construir imágenes Docker
set -e

echo "🐳 Construyendo imágenes Docker..."

# Construir imagen del Microservicio de Incidentes
echo "📦 Construyendo ms-incidentes..."
cd ms-incidentes
docker build -t ms-incidentes:latest .
cd ..

# Construir imagen del API Gateway
echo "📦 Construyendo api-gateway..."
cd api-gateway
docker build -t api-gateway:latest .
cd ..

echo "✅ Imágenes construidas exitosamente!"
echo "📋 Imágenes disponibles:"
docker images | grep -E "(ms-incidentes|api-gateway)"