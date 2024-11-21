#!/bin/sh

echo "Welcome to minikube - 🔥 Let's fire it!"

minikube start \
--cpus=4 \
--memory=8192mb \
--driver=hyperkit \
--vm=true \

#--memory=2200mb
#--driver=hyperkit (useful for nginx-ingress controller)
#--driver=docker
minikube docker-env

echo "Enabling addon: metrics server"

minikube addons enable metrics-server

minikube addons enable ingress

minikube addons enable ingress-dns

minikube addons enable istio-provisioner

minikube addons enable istio

`eval $(minikube docker-env)`

`eval $(minikube -p minikube docker-env)`

echo "Done! Ready to roll!"
