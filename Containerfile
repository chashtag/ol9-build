FROM fedora:latest

RUN dnf install -y --no-docs --setopt=install_weak_deps=False virt-install cpio libvirt-daemon-kvm && \
    adduser virtbuilder -m -u1000 && mkdir /build && chown 1000:1000 /build \
    && dnf clean all \
  	&& rm -rf /var/cache/yum

USER virtbuilder

WORKDIR /home/virtbuilder
