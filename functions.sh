#!/bin/bash

function die() {
    if [[ -n $1 ]]; then
        echo "$1"
    fi
    exit -1
}

function bootstrap() {
    # Lock the states and pillar to a specific hash
    states_hash=ed75ab9e2a7038b0996a80f577630909ed21ecc3
    pillar_hash=84a53b1462fc7e8a52fb7b3c9350a78e64fcfbcc

    if [[ -z $states_hash ]] || [[ -z $pillar_hash ]]; then
        echo "Need to set states and pillar hashes"
        exit -1
    fi

    states_dir=/srv/salt
    pillar_dir=/srv/pillar
    rm -rf $states_dir
    rm -rf $pillar_dir

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
