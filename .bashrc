# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
     *) return;;
esac

export TERM=msys

# Run to change code page to unicode in windows.
# ~/bin/chcp.com 65001

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar
shopt -s extglob

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

	function get_upstream_diff {
		# Find how many commits we are ahead/behind our upstream

		local upstream=$(git rev-parse --abbrev-ref ${parsed_branch}@{upstream})
		local count="$(git rev-list --count --left-right ${upstream}...HEAD 2>/dev/null)"
		local ahead="${count:(-1)}"
		local behind="${count:0:1}"

		# calculate the result
		case "$count" in
		"") # no upstream
			diff="" ;;
		0*0) # equal to upstream
			diff="=" ;;
		0*) # ahead of upstream
			diff="$Green+${ahead}" ;;
		*"  0") # behind upstream
			diff="$Yellowe-${behind}" ;;
		*)      # diverged from upstream
			diff="$Red+${ahead}-${behind}" ;;
		esac

		echo $diff
	}

	function parse_git_dirty {
		#changes in index

		output=""

		git diff-index --cached --quiet --diff-filter=A HEAD 2>/dev/null
		if [[ $? != 0 ]]; then
			output="$output$Green+"
		fi

		git diff-index --cached --quiet --diff-filter=M HEAD 2>/dev/null
		if [[ $? != 0 ]]; then
			output="$output$Green*"
		fi

		git diff --quiet 2>/dev/null
		if [[ $? != 0 ]]; then
			output="$output$Yellow*"
		fi

		if [[ $(git ls-files --exclude-standard --others 2>/dev/null) != "" ]]; then
			output="$output${Yellow}+"
		fi

		if [ $output ]; then
			echo -n " $output"
		fi
	}

	function parse_git_branch {
	  git rev-parse --abbrev-ref HEAD 2>/dev/null
	}

	function display_git_status {
		parsed_branch=$(parse_git_branch)
		if [[ $parsed_branch ]]; then
			parsed_branch="${parsed_branch}"
#            upstream_diff=$(get_upstream_diff)
#           dirty_status=$(parse_git_dirty)
#echo "${Reset} [${Yellow}${parsed_branch}${dirty_status}${Reset}]"
echo "${Reset} [${Yellow}${parsed_branch}${Reset}]"
		fi
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

	PS1+="${Yellow}${ShortDir}$(display_git_status)\n"

	if [[ $ExitStatus != 0 ]]; then
		PS1+="${Red}${ExitStatus}"
	fi

	PS1+="${ExecuteSymbol}${Reset}"
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


#function EXT_COLOR () { echo -ne "\[\033[38;5;$1m\]"; }

# set a fancy prompt
#export PS1="`EXT_COLOR 172`[\u@\h \W]\$${NO_COLOUR} "
