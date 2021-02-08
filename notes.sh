control01 | CHANGED | rc=0 >>
a9319ebd-053c-4c25-8220-39dae86a82ff
worker01 | CHANGED | rc=0 >>
d8ba7afa-f7c0-4624-9315-7ffb232d6992
worker02 | CHANGED | rc=0 >>
6452a189-ef00-4aab-b004-269d88e34576

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout registry.key \
-out registry.crt -subj "/CN=registry.cube.local" \
-addext "subjectAltName=DNS:registry.cube.local,DNS:*.cube.local,IP:10.40.0.52"

echo "10.40.0.52 registry registry.cube.local" >> /etc/hosts

ansible cube -b -m lineinfile -a "path='/etc/hosts' line='10.40.0.53 openfaas openfaas.cube.local'"

helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=wouterstemgee.be \
  --set global.hosts.externalIP=10.40.0.55 \
  --set certmanager-issuer.email=wouterstemgee@gmail.com

curl -sfL https://get.k3s.io | sh -s - server --cluster-init --disable traefik --disable servicelb

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.1.0 \
  --set installCRDs=true

  WUQx3eo5rXGDHlSye4xAoI_qt07h0Fa6zqtVKr5U