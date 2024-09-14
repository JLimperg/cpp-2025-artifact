# I had to increase my nofiles ulimit (to 65535) to run this Dockerfile.

FROM debian:bookworm-20240904

RUN apt-get update && \
    apt-get install -y curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf -o /tmp/elan-init.sh && \
    sh /tmp/elan-init.sh -y --default-toolchain none && \
    rm /tmp/elan-init.sh
ENV PATH="/root/.elan/bin:$PATH"

ADD tmp/artifact/aesop/lean-toolchain /tmp/toolchain
RUN bash -c 'elan toolchain install $(cat /tmp/toolchain)'

ADD tmp/artifact/mathlib/lean-toolchain /tmp/toolchain
RUN bash -c 'elan toolchain install $(cat /tmp/toolchain)'

ADD tmp/artifact /artifact

# HACK: this seems to be the least bad way to get the dependencies' sources.
WORKDIR /artifact/aesop
RUN lake build +Batteries.Logic && \
    rm -rf .lake/packages/batteries/.lake

# Here we want to keep the proofwidgets build artifacts because proofwidgets uses a binary release.
WORKDIR /artifact/mathlib
RUN lake build proofwidgets

WORKDIR /artifact
ENTRYPOINT /bin/bash
