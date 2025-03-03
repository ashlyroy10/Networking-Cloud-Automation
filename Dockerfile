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
        curl && \
    rm -rf /var/lib/apt/lists/*

# Set Python 3.8 as the default Python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2

# Install pip for Python 3.8
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.8 get-pip.py && \
    rm get-pip.py

# Copy your Ansible playbook and inventory files into the container
COPY . /app
WORKDIR /app

# Run the Ansible playbook
CMD ["ansible-playbook", "-i", "inventory.yml", "playbook.yml"]
