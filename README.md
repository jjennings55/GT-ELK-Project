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
- _TODO: What does Filebeat watch for?_
- _TODO: What does Metricbeat record?_

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

Only the _____ machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- _TODO: Add whitelisted IP addresses_

Machines within the network can only be accessed by _____.
- _TODO: Which machine did you allow to access your ELK VM? What was its IP address?_

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
You won't need to write custom code to automate your systems; you list the tasks required to be done by writing a playbook, and Ansible will figure out how to get your systems to the state you want them to be in.

The playbook implements the following tasks:
- _TODO: In 3-5 bullets, explain the steps of the ELK installation play. E.g., install Docker; download image; etc._
- ...
- ...

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![TODO: Update the path with the name of your screenshot of docker ps output](Images/docker_ps_output.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- _TODO: List the IP addresses of the machines you are monitoring_

We have installed the following Beats on these machines:
- _TODO: Specify which Beats you successfully installed_

These Beats allow us to collect the following information from each machine:
- _TODO: In 1-2 sentences, explain what kind of data each beat collects, and provide 1 example of what you expect to see. E.g., `Winlogbeat` collects Windows logs, which we use to track user logon events, etc._

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
For ELK VM Configuration:
-Copy the https://github.com/jjennings55/GT-ELK-Project/blob/47ef71da02be33c6e8bc34af9cc3ff511dc98d91/Ansible/install-elk.yml.txt
-Run the playbook with 'ansible-playbook install-elk.yml'

For Filebeat
-Download Filebeat playbook usng this command:
-curl -L -O https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/files/filebeat-config.yml
-Copy the '/etc/ansible/files/filebeat-config.yml' file to '/etc/filebeat/filebeat-playbook.yml'
-Update the filebeat-playbook.yml file to include installer by running the following command <curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-amd64.deb>
-Update the filebeat-config.yml file at /etc/ansible/ by running the command 'nano filebeat-config.yml'

output.elasticsearch:
  #Array of hosts to connect to.
 hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme” 

 setup.kibana:
  host: "10.1.0.4:5601"

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._
