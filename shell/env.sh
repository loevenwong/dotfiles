export EDITOR="subl"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export HIST_STAMPS="dd.mm.yy"
export DEFAULT_USER=jaekel

# homebrew
export PATH="/usr/local/sbin:$PATH"

# use coreutils instead of osx ones
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# use home .bin folder
export PATH="/Users/jaekel/.bin:$PATH"

export POWERLEVEL9K_MODE='awesome-patched'

docker_env
