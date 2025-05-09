# conda-auto-env automatically activates a conda environment when
# entering a folder with an '.conda-env' file.
#
# If the environment doesn't exist, conda-auto-env creates it and
# activates it for you.
#
# To install add this line to your .bashrc or .bash-profile:
#
#       source /path/to/conda_auto_env.sh
#
CONDA_AUTO_FILE=".conda-env"


function conda_auto_env() {
  if [ -e "${CONDA_AUTO_FILE}" ]; then
    echo "${CONDA_AUTO_FILE} file found"
    ENV=$(head -n 1 ${CONDA_AUTO_FILE} | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      conda activate $ENV
      if [ $? -eq 0 ]; then
        :
      else
        echo "Conda environment name '${ENV}' doesn't exist."
      fi
    fi
  fi
}

# Detect the shell and set the hook accordingly
if [[ $SHELL == *"zsh"* ]]; then
  autoload -U add-zsh-hook
  add-zsh-hook chpwd conda_auto_env
elif [[ $SHELL == *"bash"* ]]; then
  PROMPT_COMMAND="conda_auto_env; $PROMPT_COMMAND"
fi
