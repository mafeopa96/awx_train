#!/bin/bash

echo "================================================"
echo "AWX Post-Deployment Scanner Setup"
echo "================================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on RHEL-based system
if [ ! -f /etc/redhat-release ]; then
    echo -e "${YELLOW}Warning: This script is designed for RHEL-based systems${NC}"
fi

echo -e "\n${GREEN}Step 1: Installing required packages${NC}"
sudo yum install -y ansible python3-pip git || {
    echo -e "${RED}Failed to install packages${NC}"
    exit 1
}

echo -e "\n${GREEN}Step 2: Installing Python dependencies${NC}"
pip3 install --user kubernetes google-auth openshift jmespath || {
    echo -e "${YELLOW}Warning: Some Python packages failed to install${NC}"
}

echo -e "\n${GREEN}Step 3: Installing Ansible collections${NC}"
ansible-galaxy collection install -r requirements.yml || {
    echo -e "${YELLOW}Warning: Some collections failed to install${NC}"
}

echo -e "\n${GREEN}Step 4: Creating directory structure${NC}"
mkdir -p {inventory/group_vars,playbooks,roles/post_scan/{tasks,vars,templates}}

echo -e "\n${GREEN}Step 5: Setting permissions${NC}"
chmod +x setup.sh
chmod 644 ansible.cfg
chmod 600 inventory/hosts.ini

echo -e "\n${GREEN}Step 6: Validating inventory${NC}"
ansible-inventory --list -i inventory/hosts.ini > /dev/null 2>&1 && {
    echo -e "${GREEN}✓ Inventory validation passed${NC}"
} || {
    echo -e "${RED}✗ Inventory validation failed${NC}"
}

echo -e "\n${GREEN}Step 7: Testing playbook syntax${NC}"
ansible-playbook playbooks/post_deployment_scan.yml --syntax-check && {
    echo -e "${GREEN}✓ Playbook syntax check passed${NC}"
} || {
    echo -e "${RED}✗ Playbook syntax check failed${NC}"
}

echo -e "\n${GREEN}================================================"
echo "Setup Complete!"
echo "================================================${NC}"
echo -e "\nTo run a scan:"
echo -e "  ${YELLOW}ansible-playbook playbooks/post_deployment_scan.yml -e 'deployment_type=onprem'${NC}"
echo -e "\nTo run in AWX:"
echo "  1. Create a new Project pointing to this directory"
echo "  2. Create a Job Template using playbooks/post_deployment_scan.yml"
echo "  3. Add survey with 'deployment_type' variable"
echo ""
