#!/bin/bash

# Install VSCode extensions.
# These get installed to $CONDA_PREFIX/envs/notebook/share/code-server/extensions/

extensions=("ms-toolsai.jupyter" "ms-toolsai.vscode-jupyter-powertoys" "ms-python.debugpy" "eamodio.gitlens" "esbenp.prettier-vscode" "njpwerner.autodocstring" "quarto.quarto" "ms-python.python")

for EXT in "${extensions[@]}"; do
    code-server --version
    code-server --install-extension "${EXT}"
done
