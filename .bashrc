
if infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
elif [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
fi;

# displaying branch name if in git repository
# taken from https://github.com/mathiasbynens/dotfiles/blob/main/.bash_prompt
prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	git rev-parse --is-inside-work-tree &>/dev/null || return;

	# Check for what branch we’re on.
	# Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
	# tracking remote branch or tag. Otherwise, get the
	# short SHA for the latest commit, or give up.
	branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
		git describe --all --exact-match HEAD 2> /dev/null || \
		git rev-parse --short HEAD 2> /dev/null || \
		echo '(unknown)')";

	# Early exit for Chromium & Blink repo, as the dirty check takes too long.
	# Thanks, @paulirish!
	# https://github.com/paulirish/dotfiles/blob/dd33151f/.bash_prompt#L110-L123
	repoUrl="$(git config --get remote.origin.url)";
	if grep -q 'chromium/src.git' <<< "${repoUrl}"; then
		s+='*';
	else
		# Check for uncommitted changes in the index.
		if ! $(git diff --quiet --ignore-submodules --cached); then
			s+='+';
		fi;
		# Check for unstaged changes.
		if ! $(git diff-files --quiet --ignore-submodules --); then
			s+='!';
		fi;
		# # Check for untracked files.
		# if [ -n "$(git ls-files --others --exclude-standard)" ]; then
		# 	s+='?';
		# fi;
		# # Check for stashed files.
		# if $(git rev-parse --verify refs/stash &>/dev/null); then
		# 	s+='$';
		# fi;
	fi;

	[ -n "${s}" ] && s=" [${s}]";

	echo -e "${1}${branchName}${2}${s}";
}

# colors
orange=$(tput setaf 166);
yellow=$(tput setaf 228);
green=$(tput setaf 71);
blue=$(tput setaf 33);
violet=$(tput setaf 61);
white=$(tput setaf 15);
bold=$(tput bold);
reset=$(tput sgr0);

# prompt
PS1="\[${bold}\]\n";
PS1+="\[${orange}\]\u"; # username
PS1+="\[${white}\] at ";
PS1+="\[${yellow}\]\h"; # host
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\W"; # working directory
PS1+="\[\`prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\"\`\]"; # git repository details
PS1+="\n";
PS1+="\[${white}\]\$ \[${reset}\]"; # '$', reset color

export PS1;

# source .bash_aliases if it exists

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
