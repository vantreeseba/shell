# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500
HISTFILESIZE=500

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

set_prompt () {
    ExitStatus=$?

    Reset='\[\e[00m\]'
    # Regular Colors
    Red='\[\e[0;31m\]'          # Red
    Green='\[\e[0;32m\]'        # Green
    Yellow='\[\e[0;33m\]'       # Yellow
    Blue='\[\e[0;34m\]'         # Blue
    Purple='\[\e[0;35m\]'       # Purple
    Cyan='\[\e[0;36m\]'         # Cyan
    White='\[\e[0;37m\]'        # White

    function parse_git_dirty {
        #dump to a file, cause grep is retard.
        local output=$(git status -sb 2>/dev/null)
        if [[ $output != "" ]]; then

            echo "$output" > ~/.git_status_tmp
            #GREEEP
            #untracked files
            grep --mmap -Gq '^??' ~/.git_status_tmp && echo -n "$Yellow+" &
            #added files
            grep --mmap -Gq '^A.' ~/.git_status_tmp && echo -n "$Green+" &
            #unadded modified files
            grep --mmap -Gq '^.M' ~/.git_status_tmp && echo -n "$Yellow*" &
            #added modified files
            grep --mmap -Gq '^M.' ~/.git_status_tmp && echo -n "$Green*" &
            #unadded deleted files
            grep --mmap -Gq '^.D' ~/.git_status_tmp && echo -n "$Red-" &
            #added deleted files
            grep --mmap -Gq '^D.' ~/.git_status_tmp && echo -n "$Green-" &

            wait
            rm ~/.git_status_tmp &
        fi
    }

    function parse_git_branch {
      git rev-parse --abbrev-ref HEAD 2>/dev/null
    }

    PS1="\n"
    Host="\\h"
    UserAtHost="\\u@\\h"
    ShortDir="\\w"

    if [[ $EUID == 0 ]]; then
        ExecuteSymbol="$Red#"
     else
        ExecuteSymbol="$Green>"
    fi

    PS1+="$Yellow$ShortDir"

    ParsedBranch=$(parse_git_branch)
    if [[ $ParsedBranch ]]; then
        PS1+="$Reset[$ParsedBranch$(parse_git_dirty)$Reset]"
    fi

    PS1+="\n"

    if [[ $ExitStatus != 0 ]]; then
        PS1+="$Red$ExitStatus"
    fi

    PS1+="$ExecuteSymbol$Reset"
}

PROMPT_COMMAND='set_prompt'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  if [ -f /etc/git-completion.bash ]; then
    . /etc/git-completion.bash
  fi
fi


# Deal with history in multiple terminals
# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups
# append history entries..
shopt -s histappend
