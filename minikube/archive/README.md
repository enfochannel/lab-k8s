<b>Minikube</b>

ccat server.js

ccat Dockerfile

minikube start --cpus=4 --memory=1990 --driver=docker

minikube docker-env

eval $(minikube docker-env)

eval $(minikube -p minikube docker-env)

docker build -t hello-kube:v1 .

docker images

kubectl get namespaces

kubectl create namespace dev

kubectl create namespace uat

kubectl get namespaces

kubectl run hello-kube --image=hello-node:v1 --image-pull-policy=Never --port=8080 --namespace dev
minikube service dev-service --namespace dev --url

kubectl get deployments --namespace dev

kubectl get pods --namespace dev

kubectl get events --namespace dev

kubectl expose deployment hello-kube --type=LoadBalancer --namespace dev

kubectl get services --namespace dev

minikube service hello-node --namespace dev

##Repeat the process for uat

Now update the image

kubectl describe deploy hello-node --namespace dev (check the container name)

docker build -t hello-node:v2 .

kubectl set image deployment/hello-node hello-node=hello-node:v2 --namespace dev

minikube service hello-node --namespace dev

###############
Horizontal Pod Autoscaling:





##############
Running minikube with Istio and kiali

minikube start --cpus=4 --driver=docker [Change the default settings for Docker (cpu=4, memory=depends]

minikube docker-env

eval $(minikube docker-env)

eval $(minikube -p minikube docker-env)

istioctl manifest apply --set profile=demo [--namespace namespace]

kubectl label namespace [namespace] istio-injection=enabled

##Install kiali
kubectl apply -f ${ISTIO_HOME}/samples/addons/kiali.yaml

istioctl dashboard kiali

##Delete kiali
kubectl delete -f ${ISTIO_HOME}/samples/addons/kiali.yaml --ignore-not-found

##Build docker images and repeat the above::
Get minikube ip:

minikube ip
192.168.49.2

minikube profile

output to json (copy and paste to yaml)
kubectl --namespace dev -ojson get service hello-kube

Shell to a pod:
kubectl --namespace uat exec -it hello-kube-8577499789-67mms -- bash



########Minikube Blue/Green Deployment#########
start the minikube (./fireminikube.sh)

eval $(minikube -p minikube docker-env)

enable ingress addons:

minikube addons enable ingress

create docker

create a namespace prod

run kubectl apply --filename ./manifest-prod.yaml

this will create deployment,service,ingress,hpa

get the minikube ip

update the /etc/hosts/ with new ip hello-kube.info[ingress host name]


######## Minikube with Istio ingress gateway###########
kubectl create namespace dev

docker build -t hello-kube:v1 ./apps/hello-kube/

istioctl manifest apply --set profile=demo --namespace dev

kubectl label namespace dev istio-injection=enabled

kubectl apply -f ${ISTIO_HOME}/samples/addons/kiali.yaml

kubectl apply --filename manifest-development.yaml

Determining the ingress IP and ports
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')

export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

echo "$INGRESS_PORT"

echo "$SECURE_INGRESS_PORT"

export INGRESS_HOST=$(minikube ip)

echo "$INGRESS_HOST"

Open following in a new terminal window
minikube tunnel

kubectl get services --namespace deve

EXTERNAL-IP - should be populated to 127.0.0.1

gateway URL
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

echo "$GATEWAY_URL"

Setup ingress GATEWAY (namespace dev)
kubectl apply --filename manifest-istio-ingress-gateway.yaml

kubectl get getway --namespace dev

Route Traffic to the Service with VirtualService
kubectl apply --filename manifest-istio-virtualservice.yaml

To be noted:
The Ingress Gateway only tells what traffic can go inside, but VirtualService can tell where the traffic should go.
namespace: dev
gateways: [name-of-the-gateway-created-in-previous-step]

kubectl get virtualservice --namespace dev [alternative kubectl get vs -n dev]

Run:
curl http://127.0.0.1
Hello Kubernetes World!


Canary deployment using Istio
docker build -t hello-kube:v2 ./apps/hello-kube/

kubectl apply --filename ./istio-ingress/manifest-new-service-deployment.yaml

kubectl get deployments,services --namespace dev

kubectl apply --filename ./istio-ingress/manifest-istio-virtualservice-50-50.yaml
