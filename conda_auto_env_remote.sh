#!/bin/bash

# conda-auto-env automatically activates a conda environment when
# entering a folder with an ${CONDA_AUTO_FILE} file.
#
# If the environment doesn't exist, conda-auto-env creates it and
# activates it for you.
#
# To install add this line to your .bashrc or .bash-profile:
#
#       source /path/to/conda_auto_env_remote.sh
#
# conda-auto-env also supports remote anaconda.org environments.
# To specify a remote environment create an environment-remote.yml
# file with the name and channel of your environment
CONDA_AUTO_FILE=".conda-env"

function conda_auto_env_remote() {
  if [ -e "${CONDA_AUTO_FILE}" ]; then
    # echo "${CONDA_AUTO_FILE} file found"
    ENV=$(head -n 1 ${CONDA_AUTO_FILE} | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      source activate $ENV
      if [ $? -eq 0 ]; then
        :
      else
        # Create the environment and activate
        echo "Conda env '$ENV' doesn't exist."
        conda env create -q
        source activate $ENV
      fi
    fi
  fi
  if [ -e "environment-remote.yml" ]; then
    # echo "${CONDA_AUTO_FILE} file found"
    ENV=$(sed -n '1p' environment-remote.yml | cut -f2 -d ' ')
    CHANNEL=$(sed -n '2p' environment-remote.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      source activate $ENV
      if [ $? -eq 0 ]; then
        :
      else
        # Create the environment and activate
        echo "Conda env '$ENV' doesn't exist."
        REMOTE=$CHANNEL'/'$ENV
        conda env create $REMOTE -q
        source activate $ENV
      fi
    fi
  fi
}

export PROMPT_COMMAND=conda_auto_env_remote
