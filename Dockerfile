FROM debian:sid

# Install basic tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo \
    build-essential \
    uuid-dev \
    git \
    python3 \
    gosu

# Install specific tools for xxx builds
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xxx

# Install Cross-compiler
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gcc-aarch64-linux-gnu

# Copy host setup script to be run during installation
COPY hostsetup.sh /usr/local/bin/hostsetup.sh

# copy entry point
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /app

RUN groupadd -r --gid 1000 blduser && useradd --uid 1000 -g blduser blduser

# Temporary to speed up container development - add apt install
RUN echo "blduser ALL= NOPASSWD: /usr/bin/apt" > /etc/sudoers.d/blduser \
    && chmod 0440 /etc/sudoers.d/blduser

# Setup env for xxx builds
ENV XXX=xxx

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
