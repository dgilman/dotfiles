PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH
export EDITOR=vim
export PAGER=w3m
export COWPATH=/opt/local/share/cowsay
export LDFLAGS=-L/opt/local/lib/
export LESS=-R

stty erase ^H

function dgilman_git_status {
   GIT_BRANCH=$(git branch --no-color 2>/dev/null | sed -n 's/^\* \(.*\)$/\1/p')
   GIT_TAG=$(git describe --tag 2>/dev/null)
   GIT_DIRTY=$(git status --porcelain 2>/dev/null | grep -v "^??")
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
	PS1='\[\033[30m\]`date +'%H:%M'`.${debian_chroot:+($debian_chroot)}\[\033[01;30m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(dgilman_git_status)\$ '
else
	PS1='\[\033[31m\]`date +'%H:%M'`.${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(dgilman_git_status)\$ '
fi

alias w3m='w3m -F -cookie'
alias man='w3mman'
alias git='/Users/david/bin/git-achievements'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
export MANPATH=$MANPATH:/opt/local/man

source ~/.gitcompletion.sh
