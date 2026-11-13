FROM ubuntu:26.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && apt install -y gcc g++ unzip wget git python3 nodejs curl ca-certificates libclang-dev clang cargo
RUN nvim_arch="$(dpkg --print-architecture | sed 's/amd64/x86_64/')" && \
    curl -fsSL "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-${nvim_arch}.appimage" -o /tmp/nvim.appimage && \
    chmod +x /tmp/nvim.appimage && \
    cd /tmp && ./nvim.appimage --appimage-extract && \
    mv squashfs-root /opt/nvim && \
    ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.appimage
RUN cargo install tree-sitter-cli
RUN cp /root/.cargo/bin/tree-sitter /usr/local/bin/tree-sitter
COPY . /root/.config/nvim/

CMD ["/usr/local/bin/nvim"]
