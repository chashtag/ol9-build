FROM fedora:latest

RUN dnf install -y --no-docs --setopt=install_weak_deps=False virt-install cpio libvirt-daemon-kvm && \
    adduser virtbuilder -m -u2000 && mkdir /build && chown 2000:2000 /build \
    && dnf clean all \
  	&& rm -rf /var/cache/yum \
    && ln -s /home/virtbuilder/.local/share/libvirt/images/ /build

USER virtbuilder

WORKDIR /home/virtbuilder
