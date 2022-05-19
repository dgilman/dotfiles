PATH=~/dotfiles/bin:~/bin:~/gobindir/bin:/opt/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:$PATH
export PATH
export EDITOR=vim
export PAGER=less
export COWPATH=/opt/local/share/cowsay/cows/
#export LDFLAGS=-L/opt/local/lib/
export LESS="-R -S"
export MANPATH=$MANPATH:/opt/local/man
export CLOUDSDK_PYTHON=python3.8
export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib/libomp:/opt/local/lib
#export PYTHONSTARTUP="$HOME/.pythonstartup"

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
	PS1='\[\033[30m\]`date +'%H:%M'`.\[\033[2;30m\]david@lappy\[\033[00m\]:\[\033[34m\]\w\[\033[00m\]$(dgilman_git_status)\$ '
else
	PS1='\[\033[31m\]`date +'%H:%M'`.\[\033[1;31m\]david@leantaas\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(dgilman_git_status)\$ '
fi

alias w3m='w3m -F -cookie'
#alias man='w3mman'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias kill_zscalar="launchctl remove com.zscaler.tray && sudo launchctl remove com.zscaler.service && sudo launchctl remove com.zscaler.tunnel && sudo launchctl remove com.zscaler.tray.plist"

# this defines a growl function for iterm2
# usage: growl 'str'
growl() { echo -e $'\e]9;'${1}'\007' ; return ; }

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
       . /opt/local/etc/profile.d/bash_completion.sh
fi

complete -C '/opt/local/bin/aws_completer' aws
