#!/bin/bash

set -e

APPSET_FILES=applicationsets/development/appset.yaml
CLUSTER_CONFIG_FILES=configurations/development/cluster-config.yaml
#CODE_BRANCH=code
CONFIGURATION_BRANCH=configuration
DEBUG=true

function initGlobal() {
 #  codeBranch=${CODE_BRANCH:?}
    configurationBranch=${CONFIGURATION_BRANCH:?}
    cluster_config_file="${CLUSTER_CONFIG_FILES:?}"
    appset_files="${APPSET_FILES:?}"
#   export cluster_config_file appset_files codeBranch configurationBranch
    export cluster_config_file appset_files configurationBranch
}

function echoIt() {
  if [[ -n $DEBUG ]]; then
    echo "$@"
  fi
}

function updateTargetRevisionInAppset() {

    dir=gitSpace
    if [[ ! -e $dir ]]; then
      mkdir $dir
    elif [[ -d $dir ]]; then
      echo "$dir already exists...deleting it" 1>&2
      rm -rf $dir/*
    fi
    cd gitSpace

    gitlog=$(git log --format="%H" -n 1)
    echo "gitlog = $gitlog"

    git clone --branch "${configurationBranch}" "https://${GIT_TOKEN:?}@github.com/${REPOSITORY_SLUG}.git"
    cd ./*
    

    GIT_COMMIT=${gitlog}
    echo "GIT_COMMIT = $GIT_COMMIT"
    for appset_file in $appset_files; do
        echo "updating ${appset_file}"
        sed -i -E "s/targetRevision:.*/targetRevision:\ ${GIT_COMMIT}/" "${appset_file}"
        cat ${appset_file}
        git config --global user.email "xyz@gmail.com"
        git add "${appset_file}"
    done
      ( git commit -m "Auto: Changing targetRevision for ApplicationSet" && git push ) || echo "No change in appset."
}

function start() {

  REPOSITORY_SLUG="cbagade/argocd-configurations"
  echoIt "REPOSITORY_SLUG = ${REPOSITORY_SLUG}"

  initGlobal
  updateTargetRevisionInAppset
}

# execute arguments
"$@"
