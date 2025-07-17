

# Ceph CSI: RBD (RADOS Block Devices)


## Installeren

### Proxmox kant
- Maak een ceph pool `k8s-staging` via de Ceph UI
- Maak Ceph accounts:
```bash
# node is zonder mgr permission
ceph auth get-or-create \
    client.csi-rbd-k8s-staging-node \
    mon 'profile rbd' \
    osd 'profile rbd pool=k8s-staging' \
    -o csi-rbd-k8s-staging-node.keyring

# provisioner is met mgr permission
ceph auth get-or-create \
    client.csi-rbd-k8s-staging-provisioner \
    mon 'profile rbd' \
    mgr 'profile rbd pool=k8s-staging' \
    osd 'profile rbd pool=k8s-staging' \
    -o csi-rbd-k8s-staging-provisioner.keyring
```

### Kubernetes kant

- Maak een k8s namespace `k create namespace ceph-csi-rbd`

- Sta toe dat we privileged pods gaan krijgen in deze namespace (nodig voor Talos): `k label namespace ceph-csi-rbd pod-security.kubernetes.io/enforce=privileged`

- Importeer de secrets (keyring base64 van de accounts)
```
k create secret generic csi-rbd-provisioner-secret \
    --from-literal=userID=csi-rbd-k8s-staging-provisioner \
    --from-literal=userKey=$(cat csi-rbd-k8s-staging-provisioner.keyring)$ \
    --namespace=ceph-csi-rbd

# idem voor csi-rbd-node-secret
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
k apply -f test.yaml

# Check of de pod kon schrijven en lezen naar RBD
$ k logs pod/rbd-app
Ceph RBD is working!

# Opruimen
$ k delete -f test.yaml
```
