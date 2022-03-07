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
-Run the playbook with 'ansible-playbook install-elk.yml'

For Filebeat:
- Download Filebeat playbook usng this command:
- curl -L -O https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/files/filebeat-config.yml
- Copy the '/etc/ansible/files/filebeat-config.yml' file to '/etc/filebeat/filebeat-playbook.yml'
- Update the filebeat-playbook.yml file to include installer by running the following command <curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-amd64.deb>
- Update the filebeat-config.yml file at /etc/ansible/ by running the command <nano filebeat-config.yml>

output.elasticsearch:
  #Array of hosts to connect to.
 hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme” 

 setup.kibana:
  host: "10.1.0.4:5601"

- Run the playbook using the command 'ansible-playbook filebeat-playbook.yml' and navigate to Kibana > Logs : Add log data > System logs > 5:Module Status > Check data to check that the installation worked as expected.

For METRICBEAT:

- Download Metricbeat playbook using this command:
 curl -L -O https://gist.githubusercontent.com/slape/58541585cc1886d2e26cd8be557ce04c/raw/0ce2c7e744c54513616966affb5e9d96f5e12f73/metricbeat > /etc/ansible/files/metricbeat-config.yml
- Copy the /etc/ansible/files/metricbeat file to /etc/metricbeat/metricbeat-playbook.yml
- Update the filebeat-playbook.yml file to include installer:
 curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb
- Update the metricbeat file rename to metricbeat-config.yml
- Nano metricbeat-config.yml

output.elasticsearch:
#Array of hosts to connect to.
hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme"

setup.kibana:
  host: "10.1.0.4:5601"

- Run the playbook with the command 'ansible-playbook metricbeat-playbook.yml' and navigate to Kibana > Add Metric Data > Docker Metrics > Module Status to check that the installation worked as expected.
  
Answer the following questions to fill in the blanks:_
- _Which file is the playbook? All playbook files are saved in the "Playbooks" folder  Where do you copy it? copy them to your /etc/ansible folder on your Jump Box
- _Which file do you update to make Ansible run the playbook on a specific machine? hosts file How do I specify which machine to install the ELK server on versus which to install Filebeat on? The ELK server needs to be in a separate network, but any files you want logged needs to have Filebeat installed on the VM
- _Which URL do you navigate to in order to check that the ELK server is running? http://[your.VM.IP]:5601/app/kibana
