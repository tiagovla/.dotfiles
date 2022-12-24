FROM ubuntu:22.04 AS builder

ARG BUILD_APT_DEPS="ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y ${BUILD_APT_DEPS} && \
    git clone https://github.com/neovim/neovim.git /tmp/neovim --depth=1 && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=Release && \
    make CMAKE_INSTALL_PREFIX=/usr/local install && \
    strip /usr/local/bin/nvim
RUN git clone https://github.com/tiagovla/.dotfiles.git /tmp/.dotfiles --depth=1

FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && apt install -y gcc g++ unzip wget git python3 nodejs
COPY --from=builder /usr/local /usr/local/
COPY --from=builder /tmp/.dotfiles/neovim/.config/nvim /root/.config/nvim/

CMD ["/usr/local/bin/nvim"]
