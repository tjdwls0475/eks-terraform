# Remove AWS VPC CNI and install Calico CNI
k delete ds aws-node -n kube-system
git clone https://github.com/tjdwls0475/helm-calico
cd helm-calico
k create ns tigera-operator
h install calico . -n tigera-operator
# Install istio
mkdir -p ~/helm/istio/
cd ~/helm/istio/
h pull istio/base
h pull istio/istiod
h pull istio/gateway
tar xfz base-1.16.1.tgz 
tar xfz istiod-1.16.1.tgz 
tar xfz gateway-1.16.1.tgz
k create ns istio-system
h install istio-base . -n istio-system

# Configure nginx proxy

# Install aws-lb-controller

