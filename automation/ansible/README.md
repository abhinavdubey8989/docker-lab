# Aim
- This file list the steps to use Ansible to update target machines
- An example of update can be : installing docker on the target hosts


## Steps
- Clone this repo on the `workstation-node`
- Goto the dir where Ansible playbooks exists
- Run the playbook : `ansible-playbook -i inventory.yml playbook.yml`