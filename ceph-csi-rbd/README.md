

# Ceph CSI: RBD (RADOS Block Devices)


## Installeren

### Proxmox kant
- Maak een ceph pool `k8s-staging` via de Ceph UI
- Maak Ceph account:
```bash

ceph auth get-or-create \
    client.csi-rbd-k8s-staging \
    mon 'profile rbd' \
    mgr 'profile rbd pool=k8s-staging' \
    osd 'profile rbd pool=k8s-staging' \
    -o csi-rbd-k8s-staging.keyring
```

### Kubernetes kant

- Maak een k8s namespace `k create namespace ceph-csi-rbd`

- Sta toe dat we privileged pods gaan krijgen in deze namespace (nodig voor Talos): `k label namespace ceph-csi-rbd pod-security.kubernetes.io/enforce=privileged`

- Importeer de secrets (keyring base64 van de account)
```
k create secret generic ceph-csi-rbd \
    --from-literal=userID=csi-rbd-k8s-staging \
    --from-literal=userKey=$(cat csi-rbd-k8s-staging.keyring)$ \
    --namespace=ceph-csi-rbd
```

- Voeg de Helm repository toe als je dat nog niet gedaan hebt:
```bash
$ helm repo add ceph-csi https://ceph.github.io/csi-charts`
```

- Indien nodig, sla de standaard values op:
```bash
$ helm show values ceph-csi/ceph-csi-rbd > values-default.yaml
```

- Installer de Helm chart:
```bash
$ helm install \
    --namespace ceph-csi-rbd \
    -f values.yaml \
    ceph-csi-rbd \ # Naam vd deployment
    ceph-csi/ceph-cs-rbd # De chart
```

## Testen

Om te testen of RBD werkt:

```bash
cd test

# Deploy test app
k apply -f test-rbd.yaml

# Check of de pod kon schrijven en lezen naar RBD
$ k logs pod/rbd-app
Ceph RBD is working!

# Opruimen
$ k delete -f test-rbd.yaml
```
