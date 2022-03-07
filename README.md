# GT-ELK-Project
## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

https://github.com/jjennings55/GT-ELK-Project/blob/47ef71da02be33c6e8bc34af9cc3ff511dc98d91/Diagrams/Elk%20Network%20Cloud%20Diagram.pptx

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the yml and config file may be used to install only certain pieces of it, such as Filebeat.

https://github.com/jjennings55/GT-ELK-Project.git

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly redundant, in addition to restricting access to the network.
-What aspect of security do load balancers protect? It prevents against DOS attacks, and reduncancy is an aspect of high availability.  High availability and redundancy decrease the chances of your security team being locked out and attacks impacting productivity.
-What is the advantage of a jump box? It creates an out of band remote access method for administrators to always have access to the network for security and troubleshooting.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the data and system logs.
- What does Filebeat watch for?  Filebeat monitors the log files, collects log events, and forwards to Elasticsearch or Logstash.
- What does Metricbeat record? Metricbeat collects metrics and statistics and sends to Elasticsearch or Logstash.

The configuration details of each machine may be found below.
| Name        | Function        | IP Address         | Operating System |
|-------------|-----------------|--------------------|------------------|
| Jump Box    | Gateway         | 10.1.0.4   	     | Linux            |
| Web-1       | Server          | 10.1.0.5   	     | Linux            |
| Web-2       | Server          | 10.1.0.6   	     | Linux            |
| Web-3       | Server          | 10.1.0.7           | Linux            |
| Workstation | Access          | External/Public IP | Linux            |
| Loadbalancer| Loadbalancer    | 52.142.49.139      | Linux            |
| ELK         | ELK Server      | 20.122.199.195     | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the ELK Server machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- Workstation Public IP through port 5601

Machines within the network can only be accessed by my Workstation and the Jump Box.
- Which machine did you allow to access your ELK VM? What was its IP address? Jump Box IP: 10.1.0.4 via SSH or Workstation Public IP over port 5601

A summary of the access policies in place can be found in the table below.

| Name     	   | Publicly Accessible | Allowed IP Addresses  |
|------------------|---------------------|-----------------------|
| Jump Box 	   | No                  | Workstation IP on SSH |
| Web-1    	   | No                  | 10.1.0.4              |
| Web-2    	   | No                  | 10.1.0.4              |
| Web-3    	   | No                  | 10.1.0.4              |
| Loadbalanacer    | No                  | Workstation IP on HTTP|
| ELK Server       | No                  | Workstation IP on 5601|

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because Ansible lets you quickly and easily deploy multitier apps. 
You list the tasks needed to be done by writing a playbook, and Ansible will figure out how to get your systems to the state you want them to be in, as long as the playbook syntax and commands are correct.

This playbook implements the following tasks:
- Specify a group of machines with a remote user:
  - name: Configure Elk VM with Docker
    hosts: elk
    remote_user: azureuser
    become: true
    tasks:

- Install Docker and Python3-pip:
    - name: Install docker.io
      apt:
        force_apt_get: yes
        update_cache: yes
        name: docker.io
        state: present

    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present

    - name:  Docker
      pip:
        name: docker
        state: present

- Increase virtual memory:
    - name: Increase virtual memory
      command: sysctl -w vm.max_map_count=262144

    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: 262144
        state: present
        reload: yes
- Establish ports to be used:
    - name: Elk container download
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        published_ports:
          - 5601:5601
          - 9200:9200
          - 5044:5044
- Enable Docker on startup:
    - name: Enable service docker on boot
      systemd:
        name: docker
        state: started
        enabled: yes

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

https://github.com/jjennings55/GT-ELK-Project/blob/504523048939d12d6d33457d72f8bfbb4a1c59b1/Screenshots/Elk%20Status.JPG

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1 10.1.0.5
- Web-2 10.1.0.6
- Web-3 10.1.0.7

We have installed the following Beats on these machines:
- Elk Server, Web-1, Web-2, and Web-3 have Fielbeat and MetricBeat installed

These Beats allow us to collect the following information from each machine:
- Filebeat logs events, and Metric beat provides metrics and system statistics

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
For ELK VM Configuration:
-Copy the https://github.com/jjennings55/GT-ELK-Project/blob/47ef71da02be33c6e8bc34af9cc3ff511dc98d91/Ansible/install-elk.yml.txt
-Run the playbook with ansible-playbook install-elk.yml

For Filebeat:
- Download Filebeat playbook usng this command:
- curl -L -O https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/files/filebeat-config.yml
- Copy the '/etc/ansible/files/filebeat-config.yml' file to '/etc/filebeat/filebeat-playbook.yml'
- Update the filebeat-playbook.yml file to include installer by running the following command curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-amd64.deb
- Update the filebeat-config.yml file at /etc/ansible/ by running the command nano filebeat-config.yml

```bash
output.elasticsearch:
  #Array of hosts to connect to.
 hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme” 

 setup.kibana:
  host: "10.1.0.4:5601"
```
- Run the playbook using the command `ansible-playbook filebeat-playbook.yml` and navigate to Kibana > Logs : Add log data > System logs > 5:Module Status > Check data to check that the installation worked as expected.

For METRICBEAT:

- Download Metricbeat playbook using this command:
 curl -L -O https://gist.githubusercontent.com/slape/58541585cc1886d2e26cd8be557ce04c/raw/0ce2c7e744c54513616966affb5e9d96f5e12f73/metricbeat > /etc/ansible/files/metricbeat-config.yml
- Copy the /etc/ansible/files/metricbeat file to /etc/metricbeat/metricbeat-playbook.yml
- Update the filebeat-playbook.yml file to include installer:
 curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb
- Update the metricbeat file rename to metricbeat-config.yml
- `Nano metricbeat-config.yml`

```bash
output.elasticsearch:
#Array of hosts to connect to.
hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme"

setup.kibana:
  host: "10.1.0.4:5601"
```
- Run the playbook with the command `ansible-playbook metricbeat-playbook.yml` and navigate to Kibana > Add Metric Data > Docker Metrics > Module Status to check that the installation worked as expected.
  
Answer the following questions to fill in the blanks:_
- _Which file is the playbook? All playbook files are saved in the "Playbooks" folder  Where do you copy it? copy them to your /etc/ansible folder on your Jump Box
- _Which file do you update to make Ansible run the playbook on a specific machine? hosts file How do I specify which machine to install the ELK server on versus which to install Filebeat on? The ELK server needs to be in a separate network, but any files you want logged needs to have Filebeat installed on the VM
- _Which URL do you navigate to in order to check that the ELK server is running? http://[your.VM.IP]:5601/app/kibana


# Cheat Sheet - Cloud Security-1

## Key Terms

- **Term**: IaaS or 'Infrastructure as a service'
  > **Definition**: A vendor provides clients pay-as-you-go access to storage, networking, servers and other computing resources in the cloud.

- **Term**: PaaS or 'Platform as a Service'
  > **Definition**: A service provider offers access to a cloud-based environment in which users can build and deliver applications. The provider supplies underlying infrastructure.

- **Term**: SaaS or 'Software as a Service'
  > **Definition**: A service provider delivers software and applications through the internet. Users subscribe to the software and access it via the web or vendor APIs.

- **Term**: XaaS or 'Anything as a Service'
  > **Definition**: Refers to the _all_ the offerings via cloud computing as opposed to being provided locally, or on premises.

- **Term**: DBaaS or 'Database as a Service'
  > **Definition**: Refers to cloud software that enables users to setup, operate and scale databases without having to know about the exact implementations of the specific database.

- **Term**: CaaS or 'Communications as a Service'
  > **Definition**: Refers to an outsourced communications solution. Such communications can include voice over IP (VoIP or Internet telephony), instant messaging (IM), collaboration and video conference applications.

- **Term**: DaaS or 'Data as a Service'
  > **Definition**: Refers to the concept that a companies' data product can be provided to the user on demand, regardless of geographic or organizational separation between provider and consumer.

- **Term**: Virtual Computing Or Virtual Machine 
  > **Definition**: Refers to an emulation of an entire physical computer system. Virtual machines are based on computer architectures and provide the functionality of a physical computer.
  
- **Term**: Container Computing
  > **Definition**: A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another.

- **Term**: Provisioning
  > **Definition**: In general, provisioning means "providing" or making something available. Though the term is used in a variety of contexts in IT, in cloud computing, we are referring to software that automatically configures a virtual machine or container. Examples include: Ansible, Chef and Puppet.

- **Term**: CI or Continuous Integration
  > **Definition**: Continuous integration is the practice of automating the integration of code changes from multiple contributors into a single software project.
  
- **Term**: CD or Continuos Delivery
  > **Definition**: Continuous delivery is a software release approach in which development teams produce and test code in short cycles, usually with a high degree of automation.

## Key Commands

### SSH

Secure Shell sets up an encrypted connection between two machines. Commands given on the first machine are executed on the second machine and output from the second machine is sent back to the first machine. 

The result is the ability to control a remote machine using the command line while keeping all your actions private from any would be attacker or snooper.

#### ssh-keygen

The `ssh-keygen` command creates a private/public key pair that you can use to authenticate your SSH connections. Once created, the public key is copied to the server into the `~/.ssh/known_hosts` file.

```bash
# Create an ssh public/private key pair
ssh-keygen
```

You can create a password for your SSH key if you wish, but this isn't recommended if the SSH key is going to be used for automation purposes. 

#### ssh-copy-id

The `ssh-copy-id` command will copy the public ssh key into the correct location on the remote server.

```bash
# copy the public key for 'mykey' to the ~/.ssh/known_hosts file on a remote machine
ssh-copy-id -i ~/.ssh/mykey user@<host ip>
```

#### ssh

The `ssh` command creates an ssh connection to a remote machine. If you do not have an SSH key in place, you will be prompted for a password. 

```bash
# Connect to the machine with the IP address 10.10.0.4 using the 'admin' user.
ssh admin@10.10.0.4
```

You can create multiple keys for different purposes and different machines. To specify a particular key, use the `-i` flag.

```bash
# Connect to the machine at 10.10.0.4 using a specific 'mykey' identity
ssh -i mykey.pub admin@10.10.0.4
```

### Docker

Docker allows you to run Linux containers on any server or local machine. Containers are similar to a virtual machine, except they only run the resources necessary to complete their specific task.

A container typically only runs one task. This could be a web server, or a particular application or any program you choose. They are similar to an `app` on your phone. A container is completely self sufficient and has everything it needs to run. 

#### docker pull

`docker pull` will copy a container to the server so you can run it. 

```bash
# download the 'dvwa' container from the 'cyberxsecurity' docker repository
docker pull cyberxsecurity/dvwa
```

#### docker image ls

`docker image ls` lists all of the container images that are copied to the server. Each image can be used to create any number of containers. 

```bash
docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
cyberxsecurity/ansible   latest              6657e0b22542        11 days ago         303MB
ubuntu                   18.04               775349758637        7 weeks ago         64.2MB
```

#### docker container list -a

`docker container list -a` will list _all_ of the containers on the system, including containers that are not running.

#### docker run

`docker run` will create a container from the specified image.

```bash
# Run the cyberxsecurity/ansible container
docker run cyberxsecurity/ansible

# Run the container using the image ID 6657e0b22542 
docker run 6657e0b22542
```

#### docker start 

`docker start container_name` will start a stopped container. This does not _create_ a container from a container image. Instead, it will only start a container that you already have created.

#### docker stop

`docker stop` will stop a running container. This is similar to shutting down a VM.

```bash
# stop the ansible container
docker stop ansible
```

#### docker exec

`docker exec` will execute a command directly on a container and return the output of that command to you. This is commonly used to get a bash shell on the container by executing the bash command.

```bash
# run the `bash` command on a container named 'my-container'
docker exec -it my-container /bin/bash 
```

Here the `-it` flags stand for `interactive` and `terminal` or `interactive terminal` all together. The result is that this command returns a bash shell.

#### docker attach

`docker attach` will give you a shell on the specified container. This works similarly to an SSH connection and can be used instead of the `exec` command above to get a bash shell on a container.

```bash
# connect to the container named ansible
docker attach ansible
```

#### docker image rm

`docker image rm` removes an image from the server

```bash
# Remove the dvwa container image from the server
docker image rm dvwa
```

### Ansible

Ansible is a provisioner that can be used to configure any Linux machine. There is significant documentation for how to use Ansible on their website [HERE](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html).

#### ansible all -m ping 

Ansible usually needs a file full of commands called a 'playbook' in order to complete it's tasks. However, you can also execute single commands if you wish using the `-m` flag to specify the `module` you want to use.

With this command we are using the 'ping' module (`-m`) on 'all' of the machines listed in the `hosts` file.

```bash
# Ping all of the hosts in the hosts file using the ping module
ansible all -m ping
```

#### ansible-playbook

The `ansible-playbook` command will run the contents of a `playbook.yml` file. The playbook file can be named anything you wish as long as it ends in `.yml` and it has the correct formatting.

```bash
# Run the playbook 'my-playbook.yml' 
ansible-playbook my-playbook.yml
```


#### Ansible playbooks

Playbooks always carry the `.yml` extension and begin with `---` on the first line to signify that it is a YAML file.

The first few lines of the playbook will give global settings for the file and notate what machines the playbook is to use, if you would like to run the commands as `root`, and what `tasks` are to be completed.

```bash
---
- name: Config Web VM with Docker
  hosts: web
  become: true
  tasks:
```

In this Definition, we give the playbook a descriptive `name`, specify that is to run on the machines listed under the `web` headding in the `hosts` file, specify that all commands should be run as root, and then start listing the `tasks`.
  - `name:` can be anything you wish
  - `hosts:` specify what machines are to be used. Here we are using the `web` hosts.
  - `become: true` means: 'Become the root user for all the following commands'
  - `tasks:` starts the task section where all other commands/tasks will be listed.

#### Ansible apt module

Ansible modules can easily be found by googling 'Ansible module \<name-of-thing-you-want-to-do>'

The `apt` module lets you install applications using the apt-get commands. 

```bash
# Install nano. force `apt-get` to be used instead of just `apt`
  - name: Install nano
    apt:
      force_apt_get: yes
      name: nano
      state: present
```
See all of the `apt` module options [HERE](https://docs.ansible.com/ansible/latest/modules/apt_module.html)

#### Ansible pip module

The pip module allows you to install python packages as if you were using the command `pip install`

The syntax is just like the `apt` module.

```bash
  - name: Install Docker python module
    pip:
      name: docker
      state: present
```

See all of the pip module options [HERE](https://docs.ansible.com/ansible/latest/modules/pip_module.html)

#### Ansible docker-container

The `docker-container` module can be used to download and manage Docker containers. 

Here we are downloading the container `cyberxsecurity/dvwa`, staring the container, and forwarding the host port 80 to the container port 80

```bash
  - name: download and launch a docker web container
    docker_container:
      name: dvwa
      image: cyberxsecurity/dvwa
      state: started
      published_ports: 80:80
```

To see all of the `docker-container` module options, click [HERE](https://docs.ansible.com/ansible/latest/modules/docker_container_module.html)
