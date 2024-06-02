#!/bin/bash

PROJECT_DIR="project"
INVENTORIES=("production" "staging" "development")

# Create base directories
mkdir -p ${PROJECT_DIR}/{inventories,roles,playbooks,library,module_utils,filter_plugins}

# Create inventory directories and placeholder files
for ENV in "${INVENTORIES[@]}"; do
  mkdir -p ${PROJECT_DIR}/inventories/${ENV}/{group_vars,host_vars}
  touch ${PROJECT_DIR}/inventories/${ENV}/hosts.yml
done

# Create ansible.cfg
cat <<EOL > ${PROJECT_DIR}/ansible.cfg
[defaults]
inventory = inventories/production/hosts.yml
roles_path = roles
EOL

echo "Ansible project structure has been set up in the ${PROJECT_DIR} directory."
