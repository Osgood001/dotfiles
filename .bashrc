# =============================================================================
# .bashrc - Bash Configuration File
# =============================================================================

# =============================================================================
# Basic Settings
# =============================================================================

# Set command prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Enable color support
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set default editor
export EDITOR='vim'

# =============================================================================
# Bash Options
# =============================================================================

# Enable useful bash options
shopt -s checkwinsize
shopt -s histappend

# History settings
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth

# =============================================================================
# Path Configuration
# =============================================================================

# Add Protein/ADFRsuite path
export PATH=/home/osgood/Protein/ADFRsuite_x86_64Linux_1.0/bin:$PATH

# Add local bin path
export PATH="/home/osgood/.local/bin:$PATH"

# =============================================================================
# Aliases
# =============================================================================

# File operation aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'

# Python alias
alias py=python3

# Git aliases
alias gst='git status'
alias gaa='git add . && git add --all'
alias gc='git commit -m "Auto-commit: $(date)"'
alias gl='git log --graph --pretty=oneline'
alias gco='git checkout'
alias gpu='git push --set-upstream origin'

# GPU monitoring alias
alias ns='watch -n 1 nvidia-smi'

# =============================================================================
# Function Definitions
# =============================================================================

# Git commit function
gm() {
    git commit -m "$1"
}

# Python profiling function
profile() {
    local SCRIPT=$1
    python -m cProfile -s cumulative $SCRIPT > output.csv
    head -n 20 output.csv
}

# =============================================================================
# SLURM Cluster Functions
# =============================================================================

# A800 GPU node
a800() {
    srun -p a800 --pty --gres=gpu:"$1" -t 0-0"$2":00 /bin/bash
}

# A100 80G GPU node
a100() {
    srun -p debug --pty --gres=gpu:A100_80G:"$1" -t 0-0"$2":00 /bin/bash
}

# A100 40G GPU node
a400() {
    srun -p debug --pty --gres=gpu:A100_40G:"$1" -t 0-0"$2":00 /bin/bash
}

# V100 GPU node
v100() {
    srun -p v100 --pty --gres=gpu:"$1" -t 0-0"$2":00 /bin/bash
}

# TitanV GPU node
titanv() {
    srun -p titanv --pty --gres=gpu:"$1" -t 0-0"$2":00 /bin/bash
}

# GPU nodes with CPU limits
a800_cpu() {
    srun -p a800 --pty --gres=gpu:"$1" -t 0-0"$2":00 --cpus-per-task="$3" /bin/bash
}

a100_cpu() {
    srun -p debug --pty --gres=gpu:A100_80G:"$1" -t 0-0"$2":00 --cpus-per-task="$3" /bin/bash
}

a400_cpu() {
    srun -p debug --pty --gres=gpu:A100_40G:"$1" -t 0-0"$2":00 --cpus-per-task="$3" /bin/bash
}

v100_cpu() {
    srun -p v100 --pty --gres=gpu:"$1" -t 0-0"$2":00 --cpus-per-task="$3" /bin/bash
}

# CPU-only node
cpu() {
    srun -p long --nodes=1 --ntasks=1 --cpus-per-task="$1" -t 0-0"$2":00 --pty bash
}

# OpenLAM setup function
gpt() {
    source ~/Workspace/openlam_hack/cli/setup.sh "$1"
}

# =============================================================================
# System Configuration Loading
# =============================================================================

# Load bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Load global bashrc
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# =============================================================================
# Commented Configurations (Enable as needed)
# =============================================================================

# SLURM info display alias (commented out)
# alias sinfo="sinfo -o '%20P %5D %14F %8z %10m %10d %11l %16f %N'"

# Queue status alias (commented out)
# alias sq='squeue'

# System pager setting (commented out)
# export SYSTEMD_PAGER=

# Deep learning related aliases (commented out)
# alias pytrade="nvidia-smi | grep python"
# alias cond_gen="nohup python conditional_generation.py --cond-model cont1.1_cuda11.6_gpu.sif"
# alias singularity="singularity run --nv /data/dp/singularity_image/deepmd-kit_2.1_cuda11.6_gpu.sif"
