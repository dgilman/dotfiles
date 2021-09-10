path=('~/dotfiles/bin' '~/bin' '~/gobindir/bin' '/opt/local/libexec/gnubin' '/opt/local/bin' '/opt/local/sbin' $path)
export EDITOR=vim
export PAGER=less
export LESS="-R -S"
export CLOUDSDK_PYTHON=python3.8
export DYLD_FALLBACK_LIBRARY_PATH=/opt/local/lib/libomp:/opt/local/lib
manpath=('/opt/local/libexec/gnubin/man' '/opt/local/share/man' '/usr/share/man')
unsetopt ignoreeof

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

setopt PROMPT_SUBST
function prompt_fn() {
    if [[ -v VIRTUAL_ENV ]]; then
        VENV_PREFIX="($(basename $VIRTUAL_ENV)) "
    else
        VENV_PREFIX=""
    fi
    if [ "$(id -u)" != "0" ]; then
        PS1=$'z $VENV_PREFIX%{\e[30m%}%T'.$'%{\e[2;30m%}'david@lappy$'%{\e[00m%}:%{\e[34m%}%~%{\e[00m%}$(dgilman_git_status)$ '
    else
        PS1='\[\033[31m\]`date +'%H:%M'`.\[\033[1;31m\]david@leantaas\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(dgilman_git_status)\$ '
    fi
}
precmd_functions+=(prompt_fn)

alias w3m='w3m -F -cookie'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias kill_zscalar="launchctl remove com.zscaler.tray && sudo launchctl remove com.zscaler.service && sudo launchctl remove com.zscaler.tunnel && sudo launchctl remove com.zscaler.tray.plist"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
bindkey "^R" history-incremental-pattern-search-backward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/dgilman/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

function invoke_shift(){
  DISCOE_ROOT=$(git rev-parse --show-toplevel)
  cd $DISCOE_ROOT
  if [[ $1 == *"--project"* ]]; then
    PROJECT_TASKS_PATH=$(echo $1 | sed -e 's/--project=//g' | xargs -I% find apps/% pipelines/% pipelines/pos/% -iname "tasks.py" 2>/dev/null | grep -ve "venv/" |  awk '{ print length(), $0}' | sort -n | head -n1 | awk '{print $2}' | sed 's/\/tasks.py//g')
    shift;
    PYTHONPATH=$PROJECT_TASKS_PATH/backend:$PYTHONPATH python -m invoke --search-root $PROJECT_TASKS_PATH $@
  else
    python -m invoke $@
  fi
  cd -
}
alias inv='invoke_shift --project=hat-trick'

function sourcefile() {
    set -a
    source $@
    set +a
}

source '/opt/local/libexec/google-cloud-sdk/completion.zsh.inc'
