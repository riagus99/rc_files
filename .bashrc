# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# custom color scheme
export TERM=xterm-256color

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

force_color_prompt=yes

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
     PURPLE="\[\033[0;35m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"


# determine git branch name
function parse_git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (git: \1)/'
}

# determine mercurial branch name
function parse_hg_branch(){
    hg branch 2> /dev/null | awk '{print " (" $1 ")"}'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
    # Get the name of the branch.
    branch=$(parse_git_branch)
    # if not git then maybe mercurial
    if [ "$branch" == "" ]
    then
      branch=$(parse_hg_branch)
    fi
    
    # Set the final branch string.
    BRANCH="${PURPLE}${branch}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
    if test $1 -eq 0 ; then
        PROMPT_SYMBOL="\$"
    else
        PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
    fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
    if test -z "$VIRTUAL_ENV" ; then
        PYTHON_VIRTUALENV=""
    else
        PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
    fi
}

function set_condaenv () {
    if test -z "$CONDA_DEFAULT_ENV" ; then
        CONDA_ENV=""
    else
        CONDA_ENV="${RED}(conda: $CONDA_DEFAULT_ENV)${COLOR_NONE}"
    fi
}

# Set the full bash prompt.
function set_bash_prompt () {
    # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
    # return value of the last command.
    set_prompt_symbol $?
    
    # Set the PYTHON_VIRTUALENV variable.
    set_virtualenv
    
    # Set the BRANCH variable.
    set_git_branch

    set_condaenv
    
    # Set the bash prompt variable.
    #if [ ! -z "$CONDA_DEFAULT_ENV" ]
    #then
    #    PS1+="($CONDA_DEFAULT_ENV) "
    #fi
    PS1="${CONDA_ENV} ${PYTHON_VIRTUALENV}${GREEN}\u@\h${COLOR_NONE}:${YELLOW}\w${COLOR_NONE}${BRANCH}${PROMPT_SYMBOL} "
}


#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

PROMPT_COMMAND=set_bash_prompt


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


#dsfd
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'



