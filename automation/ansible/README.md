# Aim

This file lists the steps to use Ansible to configure/deploy applications and manage remote servers from a `workstation-node`.


# Ansible Overview

* Ansible is an agentless automation tool used for configuration management, application deployment, and orchestration.
* It connects to target machines using SSH (Linux/Unix) and executes tasks defined in playbooks.
* Unlike Terraform (which is state-driven infrastructure provisioning), Ansible is primarily task-driven and configuration-focused.

Ansible executes in the following order:
1. Reads `inventory.yml`
2. Connects to target hosts via SSH
3. Loads `playbook.yml`
4. Executes tasks sequentially
5. Applies changes in an idempotent way (safe to re-run)

File Structure Behavior
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



# Current Project Structure

```
automation/ansible/
│
├── playbook/
│   ├── inventory.yml
│   ├── playbooks.yml    # all playbooks are at this level
│
```


# Initialize & Run Ansible from control-node


## 1. Add the key-pair on the control-node
- At `~/.ssh` directory on the control-node, add the pem file
- The pem file name must be same as mentioned in `inventory.yml`
- This is mandatory & without this the playbooks will not run
- Also, need to change the permission of this pem file

````bash
cd ~/.ssh && chmod 400 *.pem
````


## 2. Verify Ansible installation

```bash
ansible --version
```



## 3. Check connectivity to hosts

```bash
ansible all -i inventory.yml -m ping
```

This verifies SSH connectivity.



## 4. Run playbook

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
#         NOTE : This is needed when running a playbook 1st time from control-node,
#                subsequently running any other ansible playbook will not require `ANSIBLE_HOST_KEY_CHECKING=False`
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yml playbook.yml
```



## 5. Run playbook with specific group

```bash
ansible-playbook -i inventory.yml playbook.yml --limit app_server
```

or

```bash
ansible-playbook -i inventory.yml playbook.yml --limit kafka_node
```


## 6. Run playbook for a single host

```bash
ansible-playbook -i inventory.yml playbook.yml --limit machine_1
```


## 7. Dry run (check mode)

```bash
ansible-playbook -i inventory.yml playbook.yml --check
```



# Key Differences from Terraform

| Feature     | Terraform                   | Ansible                  |
|-------------|-----------------------------|--------------------------|
| Type        | Infrastructure provisioning | Configuration management |
| State       | Maintains state file        | Stateless                |
| Execution   | Declarative                 | Procedural (task-based)  |
| Agent       | No                          | No (SSH-based)           |
| Focus       | Infrastructure (VPC, EC2)   | OS + App setup           |
