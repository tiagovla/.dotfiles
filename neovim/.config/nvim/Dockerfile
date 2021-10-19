FROM ubuntu:20.04 AS builder

ARG BUILD_APT_DEPS="ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils"
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET=stable

RUN apt update && apt upgrade -y && \
    apt install -y ${BUILD_APT_DEPS} && \
    git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    git checkout tags/${TARGET} && \
    make CMAKE_BUILD_TYPE=Release && \
    make CMAKE_INSTALL_PREFIX=/usr/local install && \
    strip /usr/local/bin/nvim

FROM ubuntu:20.04
COPY --from=builder /usr/local /usr/local/

CMD ["/usr/local/bin/nvim"]
