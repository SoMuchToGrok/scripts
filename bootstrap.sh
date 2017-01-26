#!/bin/bash
BASE_DIR=$(dirname ${0})

# We want to lock the states and pillar to a specific hash.
states_hash=fa9c9c0b0aa00abe4787684920e09e62067ba91a
pillar_hash=a9c8902bd1c69874e5a4da7be802fb15c71c0fcc

if [[ -z $states_hash ]] || [[ -z $pillar_hash ]]; then
    echo "Need to set states and pillar hashes"
    exit -1
fi

states_dir=$BASE_DIR/saltstack/srv/salt
pillar_dir=$BASE_DIR/saltstack/srv/pillar

if [ ! -d $states_dir ]; then
  echo -n "Cloning salt states..."
  git clone git@github.com:SoMuchToGrok/salt-states.git $states_dir &> /dev/null
  echo "Done."
fi

pushd $states_dir &> /dev/null
echo -n "Setting states to correct commit..."
git fetch
git checkout -q $states_hash
echo "Done."
popd &> /dev/null

if [ ! -d $pillar_dir ]; then
  echo -n "Cloning salt pillar..."
  git clone git@github.com:SoMuchToGrok/salt-pillars.git $pillar_dir &> /dev/null
  echo "Done."
fi

pushd $pillar_dir &> /dev/null
echo -n "Setting pillar to correct commit..."
git fetch
git checkout -q $pillar_hash
echo "Done."
popd &> /dev/null
