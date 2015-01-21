#~/.bashrc: executed by bash(1) for non-login shells.
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
HISTSIZE=5000
HISTFILESIZE=5000

#I think this checks the command hash for already run commands?
shopt -s checkhash
shopt -s no_empty_cmd_completion

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar #only available in bash 4.0 I think.
shopt -s extglob;

Reset='\[\e[00m\]';

# Dark Colors
Red='\[\e[0;31m\]';         # Red
Green='\[\e[0;32m\]';       # Green
Yellow='\[\e[0;33m\]';      # Yellow
Blue='\[\e[0;34m\]';        # Blue
Purple='\[\e[0;35m\]';      # Purple
Cyan='\[\e[0;36m\]';        # Cyan
White='\[\e[0;37m\]';       # White

#Bright colors
BRed='\[\e[1;31m\]';         # Red
BGreen='\[\e[1;32m\]';       # Green
BYellow='\[\e[1;33m\]';      # Yellow
BBlue='\[\e[1;34m\]';        # Blue
BPurple='\[\e[1;35m\]';      # Purple
BCyan='\[\e[1;36m\]';        # Cyan
BWhite='\[\e[1;37m\]';       # White

set_prompt () {
	local ExitStatus=$?;

	PS1="\n"$Yellow"\w";

	#if [[ -d .git || current_branch=``]]; then
	current_branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
	if [[ $current_branch ]]; then
		PS1+=$Yellow$Reset" ["$Purple$current_branch$Reset"]";
	fi
	#fi

	if [[ $EUID == 0 ]]; then
		ExecuteSymbol=$Red"#";
	else
		ExecuteSymbol=$Green">";
	fi

	PS1+="\n"

	if [[ $ExitStatus != 0 ]]; then
		PS1+=$Red$ExitStatus
	fi

	PS1+=$ExecuteSymbol$Reset
}

PROMPT_COMMAND='set_prompt'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
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
