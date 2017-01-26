#!/bin/bash

function bootstrap() {
    BASE_DIR=$(dirname ${0})

    # We want to lock the states and pillar to a specific hash.
    states_hash=e8df0253a82470b84d2dc571f7ff24ba74840cb2
    pillar_hash=84a53b1462fc7e8a52fb7b3c9350a78e64fcfbcc

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
}
