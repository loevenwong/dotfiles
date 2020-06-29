# My alias file
# heavily stolen from mathiasbynens/dotfiles

alias history="fc -l 1"
#alias internet\?="ping -c3 8.8.8.8"
#alias ip='curl curlmyip.com'
#alias ll="ls -alG"
#alias cls="clear"
#alias ..='cd ..'
#alias ...='cd ../../'
#alias ....='cd ../../../'
#alias .....='cd ../../../../'
#alias .4='cd ../../../../'
#alias .5='cd ../../../../..'
alias cd..='cd ..'

alias docker_boot='/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh && eval $(docker-machine env default)'
alias docker_env='eval $(docker-machine env default)'
alias docker_stop_all='docker stop $(docker ps -a -q)'
alias docker_remove_all='docker stop $(docker ps -a -q)'
alias docker_bash='docker exec -it $(docker ps -q) /bin/bash'
alias docker_clean='docker_stop_all && docker_remove_all && docker rm `docker ps -aq --no-trunc --filter "status=exited"` && docker rmi `docker images --filter 'dangling=true' -q --no-trunc`'
alias docker_debian_latest='docker run -it --rm=true debian bash'
alias docker_ubuntu_latest='docker run -it --rm=true ubuntu bash'
alias docker_mailcatcher_latest='echo "stopping existent machine" && docker stop $(docker ps -a -f name=mail -q) && echo "removing previos machine" && docker rm $(docker ps -a -f name=mail -q) && echo "starting mailcatcher with port 1080 and 1025" && docker run -d -p 1080:80 -p 1025:25 --name mail tophfr/mailcatcher'

# Allows you to use docker-compose-exec {service} {command} to run a command on the service
docker_compose_exec() {
    docker exec -it $(docker-compose ps | grep $1 | awk '{print $1}') ${@:2}
  }

  alias docker-compose-exec=docker_compose_exec



alias without_comments='cat $1 | egrep -v "(^#.*|^$)"'
alias killaudio="sudo kill -9 `ps ax|grep 'coreaudio[a-z]' |awk '{print $1}'`"
alias hosts="sudo subl /etc/hosts"

alias rename_files_to_md5="/usr/local/bin/md5sum * | gsed -e 's/\([^ ]*\) \(.*\(\..*\)\)$/mv -v \2 \1\3/e'"
alias ansible_install_roles="ansible-galaxy install -r requirements.yml -p ./roles -i"

# Helper
alias dotfiles="subl ~/.dotfiles/"
alias aliases="subl ~/.dotfiles/shell/aliases.sh"
alias refresh="fresh && source ~/.zshrc && reset"
alias zshrc="subl ~/.dotfiles/zshrc"
alias freshrc="subl ~/.dotfiles/freshrc"
alias known_hosts="subl ~/.ssh/known_hosts"
alias ssh_config="subl ~/.ssh/config"
alias sourcetree="open -a SourceTree ."

# Easier navigation: .., ..., ...., ....., ~ and -
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade --all; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias cssh_sa="csshX sa-studio sa-app-01 sa-app-02 sa-app-03 sa-app-04 sa-app-05 sa-app-06 sa-app-07"
alias cssh_stoffe="csshX stoffe1 stoffe2 stoffe3 stoffe4 stoffe5"
alias cssh_sa_es="csshX sa-es-01 sa-es-02 sa-es-03"
alias cssh_eav="csshX eav-1 eav-2 eav-3 eav-4"
alias cssh_sa_at="csshX sa-at-prod2-studio1 sa-at-prod2-studio2 sa-at-prod2-app1 sa-at-prod2-app2 sa-at-prod2-app3 sa-at-prod2-app4 sa-at-prod2-app5"

