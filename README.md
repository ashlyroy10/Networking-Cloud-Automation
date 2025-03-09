# Automated Deployment of Dockerized Application on Azure

This project automates the deployment of a Dockerized web application on an Azure Virtual Machine using Terraform for infrastructure provisioning, Ansible for configuration management, Docker for containerization, and GitHub Actions for CI/CD pipeline integration.

**Prerequisites:**

Before running the project, ensure you have the following:

- Azure Account with an active subscription
  
- Terraform installed (v1.5+) → Install Guide
  
- Ansible installed (v2.9+) → sudo apt install ansible
  
- Docker installed (v20+) → sudo apt install docker.io
  
- GitHub Account & Repository with secrets configured (VM IP, Username, Password)
  

**Installation & Setup:**

1. Clone the Repository
   
    git clone https://github.com/your-username/your-repo.git
   
    cd your-repo

2. Configure Azure CLI (if not already done)
   
    az login
   
    az account show

3. Provision Infrastructure using Terraform
   
    Initialize, plan, and apply Terraform to create the Azure VM:
   
        terraform init       # Initialize Terraform
   
        terraform plan       # Preview changes
   
        terraform apply      # Deploy resources
   
    After completion, note the public IP of the VM.

4. Configure the VM using Ansible
   
    Run the Ansible playbook to install Docker and configure the environment:
   
        ansible-playbook -i "VM_IP_ADDRESS," playbook.yml -u azureuser --extra-vars "ansible_ssh_pass=VM_PASSWORD" -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"'

5. Build & Run the Docker Container (Manually, for Testing)
   
    If needed, you can manually SSH into the VM and run the following:
   
        ssh azureuser@VM_IP_ADDRESS
   
        cd /home/azureuser/hello-world-app/
   
        docker build -t hello-world-app
   
        docker run -d --name hello-world-app -p 80:80 hello-world-app
   
    Now, visit http://VM_IP_ADDRESS in a browser.

6. Automate Deployment with GitHub Actions
    
    Push changes to the main branch to trigger the GitHub Actions CI/CD pipeline:
   
        git add .
   
        git commit -m "Updated application"
   
        git push origin main

    The pipeline will:
   
        - Deploy updates using Ansible
   
        - Rebuild and restart the Docker container on the VM
   
        - Automatically reflect changes on http://VM_IP_ADDRESS

**Cleanup**

To destroy all resources created:

    terraform destroy -auto-approve

**Conclusion**

This project demonstrates an automated workflow for provisioning infrastructure, configuring a server, deploying a Dockerized application, and implementing CI/CD using GitHub Actions. It serves as a scalable and reusable framework for cloud-based deployments.  

