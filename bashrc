export PATH=~/dotfiles/bin/:$PATH
export EDITOR=vim
export PAGER=w3m
export LESS="-R -S"

function dgilman_git_status {
   GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
   GIT_TAG=$(git describe --tag 2>/dev/null)
   GIT_DIRTY=$(git status --porcelain 2>/dev/null | grep -v "^??" | head -1)
   GIT_STRING=""
   if [ ! -z "$GIT_BRANCH" ]; then
      GIT_STRING=" ""$GIT_STRING""$GIT_BRANCH"
      if [ ! -z "$GIT_TAG" ]; then
         GIT_STRING="$GIT_STRING"" @ ""$GIT_TAG"
      fi
      if [ ! -z "$GIT_DIRTY" ]; then
         GIT_STRING="$GIT_STRING"" d "
      fi
   fi
   echo -n "$GIT_STRING"
}

if [ "$(id -u)" != "0" ]; then
PS1='\[\033[35m\]`date +'%H:%M'`.${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(dgilman_git_status)\$ '
else
PS1='\[\033[31m\]`date +'%H:%M'`.${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(dgilman_git_status)\$ '
fi

alias w3m='w3m -F -cookie'
alias man='w3mman'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

#debian!?!?
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TZ=America/New_York

# enable color support of ls and also add handy aliases
if [ -x "$(command -v dircolors)" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
