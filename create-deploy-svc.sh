#!/bin/bash

# user input
read -p "Enter the Deployment Name: " deployment_name
read -p "Enter the App Label (e.g., 'box'): " app_label
read -p "Enter the Container Name: " container_name
read -p "Enter the Container Image (e.g., 'setthapong/box'): " container_image
read -p "Enter the Container Port (leave blank if unknown): " container_port
read -p "Enter the Service Name: " service_name
read -p "Enter the Service Port (the port the Service will expose): " service_port
read -p "Enter the Target Port (the port the container listens on): " target_port
read -p "Enter the NodePort (the port exposed on the node, typically >30000): " node_port

# Create YAML file
cat <<EOF > ${deployment_name}_deployment_service.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $deployment_name
  labels:
    app: $app_label
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $app_label
  template:
    metadata:
      labels:
        app: $app_label
    spec:
      containers:
      - name: $container_name
        image: $container_image
EOF

# If containerPort is provided, add it to the YAML
if [ -n "$container_port" ]; then
  cat <<EOF >> ${deployment_name}_deployment_service.yaml
        ports:
        - containerPort: $container_port
EOF
fi

# creating the YAML file for the svc
cat <<EOF >> ${deployment_name}_deployment_service.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: $service_name
  labels:
    app: $app_label
spec:
  type: NodePort
  selector:
    app: $app_label
  ports:
  - port: $service_port       
    targetPort: $target_port   
    nodePort: $node_port       
EOF

# yaml file is generated 
echo "Kubernetes deployment and service YAML file has been generated in ${deployment_name}_deployment_service.yaml"

# Apply the YAML file to the Kubernetes cluster
kubectl create -f ${deployment_name}_deployment_service.yaml

# Remove the YAML file
rm ${deployment_name}_deployment_service.yaml

