
# homelab-k8s-infra

Omvat alle infrastructurele componenten die mijn homelab clusters gebruiken bovenop de Talos OS nodes.

Momenteel omvat deze repository:

- `metallb` als `LoadBalancer` implementatie;
- `ingress-nginx` als `Ingress` implementatie;
- `ceph-csi-rbd` als Block Storage `StorageClass` implementatie;
- `ceph-csi-cephfs` als Filesystem `StorageClass` implementatie.

## MetalLB

Mijn clusters draaien in mijn homelab. Dit betekent dat qua netwerk om moet gaan met een "knooppunt" waar alle binnenkomende verbindingen doorgestuurd worden.

In een notendop is het netwerk pad als volgt:

- UniFi Gateway ->
- `ingress` VM met Caddy er op, scheidt `staging` en `prod` verkeer, termineert TLS ->
- MetalLB IP van de `ingress-nginx` `LoadBalancer` instantie ->
- `ingress-nginx` controller, die verkeer scheidt o.b.v. hostname naar de juiste `Ingress` instantie ->
- de `Ingress`  die het doorstuurt naar de `Service` van een applicatie ->
- de applicatie.
