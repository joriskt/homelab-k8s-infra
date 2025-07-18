
# ingress-nginx

The nginx ingress controller. Install or upgrade using `install-upgrade.sh`.


## Deployment

Wordt gebruikt om host names te mappen naar services. D.m.v. MetalLB krijgt de ingress controller een IP adres toegekend.

Extern aan de cluster is mijn `ingress` VM waarop Caddy de TLS termineert voor zowel `staging` als `prod`.