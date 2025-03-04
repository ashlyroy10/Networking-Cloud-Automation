# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && \
    apt install -y \
        python3.8 \
        python3.8-dev \
        python3.8-distutils \
        python3-apt \
        ansible \
        ssh \
        git \
        sshpass \
        docker.io \
        curl \
        python3-pip && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Python 3.8 as the default Python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2

# Install required Python modules
RUN pip3 install docker

# Install community.docker collection
RUN ansible-galaxy collection install community.docker

# Add the target VM's SSH host key to known_hosts
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    ssh-keyscan 40.88.13.22 >> /root/.ssh/known_hosts && \
    chmod 600 /root/.ssh/known_hosts

# Copy your Ansible playbook and inventory files into the container
COPY . /app
WORKDIR /app

# Copy the SSH private key
ARG SSH_PRIVATE_KEY
RUN echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa

# Run the Ansible playbook
CMD ["ansible-playbook", "-i", "inventory.yml", "playbook.yml"]
