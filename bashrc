PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH
export EDITOR=vim
export PAGER=w3m
export COWPATH=/opt/local/share/cowsay

if [ "$(id -u)" != "0" ]; then
	PS1='\[\033[30m\]`date +'%H:%M'`.${debian_chroot:+($debian_chroot)}\[\033[01;30m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='\[\033[31m\]`date +'%H:%M'`.${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

alias w3m='w3m -F -cookie'
alias man='w3mman'
alias git='/Users/david/bin/git-achievements'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
export MANPATH=$MANPATH:/opt/local/man

source ~/.gitcompletion.sh
