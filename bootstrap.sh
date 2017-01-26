#!/bin/bash

BASE_DIR=$(dirname ${0})

# Checks if salt is installed
dpkg -l | grep salt-minion
if [ $? -eq 0 ]; then
    echo "salt-minion is installed"
else
    curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
fi

source functions.sh

# Clone salt states and pillars repos
bootstrap

# Run salt
copy -f $BASE_DIR/salt-minion /etc/salt/minion
salt-call --local state.apply
