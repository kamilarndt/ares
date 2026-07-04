FROM python:3.12-slim

# System deps
RUN apt-get update && apt-get install -y \
    git tmux bubblewrap curl \
    && rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd -m -s /bin/bash omnigent
USER omnigent
WORKDIR /home/omnigent

# Install Omnigent
RUN pip install --no-cache-dir omnigent

# Directories for data
RUN mkdir -p /home/omnigent/harness-data /home/omnigent/agents /home/omnigent/policies

# Entrypoint
COPY --chown=omnigent:omnigent entrypoint.sh /home/omnigent/
RUN chmod +x /home/omnigent/entrypoint.sh

EXPOSE 6767
ENTRYPOINT ["/home/omnigent/entrypoint.sh"]
