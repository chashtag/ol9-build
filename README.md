# ol9-build

pre-reqs

```
sudo dnf -y install libvirt{,d} virt-manager virt-install aria2c
sudo systemctl start libvirtd
```


quickstart

```
bash <(curl -s https://raw.githubusercontent.com/chashtag/ol9-build/refs/heads/main/build.sh)
```

or in podman

```
mkdir -p output 

podman run --rm -ti -v $PWD/output:/build:z --device /dev/kvm docker.io/chashtag/virt-install:latest bash -c 'bash <(curl -s https://raw.githubusercontent.com/chashtag/ol9-build/refs/heads/main/build.sh)'

```
