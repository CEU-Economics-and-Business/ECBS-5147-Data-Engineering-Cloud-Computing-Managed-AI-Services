FROM mcr.microsoft.com/devcontainers/python:1-3.13-bookworm

RUN sudo apt-get update
RUN sudo apt-get install -y curl telnet netcat-openbsd traceroute

# Install AWS CLI v2 (do this early as it rarely changes)
RUN ARCH=$(uname -m) && \
    cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install UV
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy dependency files first for better caching
COPY pyproject.toml /workspace/pyproject.toml

# Install Python dependencies using UV
WORKDIR /workspace
RUN uv pip install --system --python /usr/local/bin/python -r pyproject.toml

# Switch to vscode user for development
USER vscode
ENV PATH=/home/vscode/.local/bin:$PATH
