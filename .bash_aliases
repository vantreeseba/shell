# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
# if [ -x /usr/bin/dircolors ]; then

# test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)
	LS_COLORS="di=0;36:ex=1;32:fi=1;30"

#code files
	LS_COLORS+=":*.js=1;35"
	LS_COLORS+=":*.c=1;35"
	LS_COLORS+=":*.cpp=1;35"

#code/build files
	LS_COLORS+=":*rakefile=0;35"
	LS_COLORS+=":*gulpfile.js=0;35"

#key value files
	LS_COLORS+=":*.json=0;33"
	LS_COLORS+=":*Gemfile=0;33"
	LS_COLORS+=":*Gemfile.lock=0;33"

#key value config/hidden files
	LS_COLORS+=":*.gitignore=1;33"
	LS_COLORS+=":*.jshintrc=1;33"

#markup text
	LS_COLORS+=":*.md=0;32"

	export LS_COLORS
    alias ls='ls --color=auto'
    alias l='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    # alias grep='grep --color=auto'
    # alias fgrep='fgrep --color=auto'
    # alias egrep='egrep --color=auto'
# fi
