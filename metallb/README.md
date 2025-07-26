
Install using `install.sh`.

On a small cluster where all nodes are control-plane nodes, make sure they **do not** have the label: `node.kubernetes.io/exclude-from-external-load-balancers`. If they do, MetalLB will never use them to announce IP addresses.

Relevant documentation for fixing the above is in my Talos repository.


## Voorwaarden

- Het netwerk waarop de nodes verbonden zijn is een vrije range van IP-adressen nodig, **buiten** de DHCP range.


## Gebruik

Het primaire doel van MetalLB in mijn cluster is om de `ingress-nginx` een IP-adres toe te kennen, ook als individuele nodes down gaan.

Vanaf daar is `ingress-nginx` verantwoordelijk voor het routen van hostnames naar de juiste services door middel van `Ingress` instanties.

De intentie is dus **niet** om individuele services IP-addressen toe te kennen!