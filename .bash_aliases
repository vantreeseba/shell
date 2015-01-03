# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

add_to_ls_colors(){
	declare -a files=(${!1})
		color=$2

		for i in ${files[@]}; do
			LS_COLORS+=":$i=$color";
	done;
}

add_filetypes_to_ls_colors(){
	archive_color="0;31";
	archive_files=(
			"*.zip"
			"*.tar"
			"*.gz"
			"*.rar"
			);

	code_color="1;35";
	code_files=(
			"*.js"
			"*.c"
			"*.cpp"
			"*.hx"
			"*.rb"
			);

	task_build_color="0;35";
	task_build_files=(
			"*rakefile"
			"*Gemfile"
			"*Gemfile.lock"
			"*gulpfile.js"
			"*.hxml"
			);

	key_value_color="0;33";
	key_value_files=(
			"*.json"
			);

	hidden_config_color="1;33";
	hidden_config_files=(
			"*.gitignore"
			"*.jshintrc"
			"*.agignore"
			"*.bash_aliases"
			"*.bashrc"
			"*.editorconfig"
			"*.jsbeautifyrc"
			"*.vimrc"
			);

	marked_up_text_color="0;32";
	marked_up_text_files=(
			"*.md"
			"*.htm"
			"*.html"
			);

	add_to_ls_colors "archive_files[@]" $archive_color;
	add_to_ls_colors "code_files[@]" $code_color;
	add_to_ls_colors "task_build_files[@]" $task_build_color;
	add_to_ls_colors "key_value_files[@]" $key_value_color;
	add_to_ls_colors "hidden_config_files[@]" $hidden_config_color;
	add_to_ls_colors "marked_up_text_files[@]" $marked_up_text_color;
}


set_presentation_ls_colors(){
	set -f; #turn off globbing

	LS_COLORS=""
	LS_COLORS+=":di=0;36"; #cyan dir
	LS_COLORS+=":fi=1;30"; #grey normal files

	add_filetypes_to_ls_colors;

	export LS_COLORS;
	set +f; #turn on globbing
}

set_default_ls_colors(){
	set -f; #turn off globbing

	LS_COLORS="fi=1;30"; #Grey normal files
	add_filetypes_to_ls_colors;

	export LS_COLORS;
	set +f; #turn on globbing
}

set_default_ls_colors;

alias ls='ls --color=auto';
alias l='ls --color=auto';
