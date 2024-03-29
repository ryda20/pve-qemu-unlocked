FROM debian:stable
RUN apt-get update
RUN apt-get install -y git
RUN mkdir -p /opt/
WORKDIR /opt/
#RUN git clone git://git.proxmox.com/git/pve-qemu
# clone repo recursive (just delete the old directory previously)
RUN git clone --recursive git://git.proxmox.com/git/pve-qemu.git
WORKDIR /opt/pve-qemu/
RUN git checkout 284d3b2cabef10362a574efe209d1d406f351dfa
RUN apt-get install -y make \
    wget \
    curl \
    sed \
    nano \
    build-essential \
    autotools-dev \
    check \
    debhelper \
    libacl1-dev \
    libaio-dev \
    libcap-dev \
    libcurl4-gnutls-dev \
    libfdt-dev \
    libglusterfs-dev \
    libgnutls28-dev \
    libiscsi-dev \
    libjemalloc-dev \
    libjpeg-dev \
    libnuma-dev \
    libpci-dev \
    libpixman-1-dev \
    librbd-dev \
    libsdl1.2-dev \
    libseccomp-dev \
    libspice-protocol-dev \
    libspice-server-dev \
    libusb-1.0-0-dev \
    libusbredirparser-dev \
    python3-minimal \
    python3-sphinx \
    quilt texi2html \
    texinfo \
    uuid-dev \
    xfslibs-dev \
    lintian
#RUN sed -i '/.*--target-list=.*/d' debian/rules
#RUN sed -i '/.*--disabled-downloads.*/d' debian/rules
RUN sed -i 's|# guest-agent|patch -p1 < 001-anti-detection.patch\n# guest-agent|g' debian/rules
RUN wget https://raw.githubusercontent.com/ryda20/proxmox-ve-anti-detection/main/001-anti-detection.patch
RUN cp 001-anti-detection.patch debian/
RUN make -j8
