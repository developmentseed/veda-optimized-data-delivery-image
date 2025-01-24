# Inherit from a JupyterHub compatible Docker image
FROM quay.io/jupyter/base-notebook:2024-10-14

RUN echo ${NB_UID}
# Add conda packages
COPY environment.yml /tmp/environment.yml
RUN mamba env update --prefix ${CONDA_DIR} --file /tmp/environment.yml

COPY apt.txt /tmp/apt.txt

USER root

RUN apt-get update && \
    xargs -a /tmp/apt.txt apt install -y && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/apt.txt

# Insall quarto
USER root
RUN wget -q https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb
RUN dpkg -i quarto-1.5.57-linux-amd64.deb


# Install rustup
ENV RUSTUP_HOME="/opt/.rustup"
ENV CARGO_HOME="/opt/.cargo"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${CARGO_HOME}/bin:${PATH}"
RUN rustup component add rust-src

USER ${NB_UID}
# Update cargo home for users
ENV CARGO_HOME="${HOME}/.cargo"
ENV PATH="${CARGO_HOME}/bin:${PATH}"

# Use solution from https://github.com/NASA-Openscapes/corn/blob/main/ci/Dockerfile
# for installing VS Code extensions.
COPY install-vscode-ext.sh ${HOME}/.kernels/install-vscode-ext.sh

RUN bash ${HOME}/.kernels/install-vscode-ext.sh

# Install icechunk development packages (these steps required from https://github.com/earth-mover/icechunk/issues/197)
RUN python -m pip install icechunk==0.1.0a15 xarray VirtualiZarr
RUN python -m pip install git+https://github.com/mpiannucci/kerchunk@v3
