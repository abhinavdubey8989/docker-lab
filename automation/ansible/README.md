# Aim

This file lists the steps to use Ansible to configure/deploy applications and manage remote servers from a `workstation-node`.


# Ansible Overview

* Ansible is an agentless automation tool used for configuration management, application deployment, and orchestration.

* It connects to target machines using SSH (Linux/Unix) and executes tasks defined in playbooks.

* Unlike Terraform (which is state-driven infrastructure provisioning), Ansible is primarily task-driven and configuration-focused.


# File Structure Behavior

* Ansible does not require strict filenames, but expects specific file types to work together:

* The main execution unit is a playbook (`*.yml` or `*.yaml`)

* Inventory defines target hosts and groups

* Roles are optional but recommended for modular design



## Core File Types

```
playbook.yml        # Main automation logic (tasks to run)
inventory.yml       # Target hosts and groups
ansible.cfg         # Global Ansible configuration (optional)
group_vars/         # Group-specific variables
host_vars/          # Host-specific variables
roles/              # Reusable automation components (optional)
```



# Recommended Project Structure

While not mandatory, this structure is widely used for scalability and clarity:

```
ansible-project-dir/
│
├── inventory.yml         # Defines target machines (EC2, servers, etc.)
├── playbook.yml          # Main execution file
├── ansible.cfg           # Configurations (optional)
│
├── group_vars/
│   ├── app_server.yml
│   ├── kafka_node.yml
│
├── host_vars/
│   ├── machine_1.yml
│
└── roles/                # Modular reusable logic (recommended for production)
    ├── app_deploy/
    ├── kafka_setup/
```



# Execution Flow in Ansible

Ansible executes in the following order:

1. Reads `inventory.yml`
2. Connects to target hosts via SSH
3. Loads `playbook.yml`
4. Executes tasks sequentially
5. Applies changes in an idempotent way (safe to re-run)



# Initialize & Run Ansible from workstation-node


## 1. Verify Ansible installation

```bash
ansible --version
```



## 2. Check connectivity to hosts

```bash
ansible all -i inventory.yml -m ping
```

This verifies SSH connectivity.



## 3. Run playbook

```bash
ansible-playbook -i inventory.yml playbook.yml

# or 

# Verbose
ansible-playbook -i inventory.yml playbook.yml -vvv

# Might get error : first-time Ansible + EC2 SSH setups
# Fix-1 : SSH into all inventory hosts before running playbook
#   - ssh ubuntu@10.0.1.196
# Fix-2 : Permanent fix (recommended for labs/dev)
#   - ~/.ansible.cfg & add `host_key_checking = False`
# Fix-3 Preload known hosts
#   - ssh-keyscan 10.0.1.196 >> ~/.ssh/known_hosts
# FIX-4 (QUICK): Disable host key checking (common in dev-environment)
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yml playbook.yml
```



## 4. Run playbook with specific group

```bash
ansible-playbook -i inventory.yml playbook.yml --limit app_server
```

or

```bash
ansible-playbook -i inventory.yml playbook.yml --limit kafka_node
```


## 5. Run playbook for a single host

```bash
ansible-playbook -i inventory.yml playbook.yml --limit machine_1
```


## 6. Dry run (check mode)

```bash
ansible-playbook -i inventory.yml playbook.yml --check
```


## 7. Skip host key verification (dev/lab only)

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yml playbook.yml
```


# Key Differences from Terraform

| Feature     | Terraform                   | Ansible                  |
|-------------|-----------------------------|--------------------------|
| Type        | Infrastructure provisioning | Configuration management |
| State       | Maintains state file        | Stateless                |
| Execution   | Declarative                 | Procedural (task-based)  |
| Agent       | No                          | No (SSH-based)           |
| Focus       | Infrastructure (VPC, EC2)   | OS + App setup           |
