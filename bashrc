# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export WORKON_HOME=$HOME/.virtualenvs   # optional
export PROJECT_HOME=$HOME/projects      # optional
source /usr/bin/virtualenvwrapper.sh

SEND_256_COLORS_TO_REMOTE=1

# bash_prompt
# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

 # Detect whether the current directory is a git repository.
 function is_git_repository {
   git branch > /dev/null 2>&1
 }

 # Determine the branch/state information for this git repository.
 function set_git_branch {
   # Capture the output of the "git status" command.
   git_status="$(git status 2> /dev/null)"

   # Set color based on clean/staged/dirty.
   if [[ ${git_status} =~ "working directory clean" ]]; then
     state="${GREEN}"
   elif [[ ${git_status} =~ "Changes to be committed" ]]; then
     state="${YELLOW}"
   else
     state="${LIGHT_RED}"
   fi

   # Set arrow icon based on status against remote.
   remote_pattern="# Your branch is (.*) of"
   if [[ ${git_status} =~ ${remote_pattern} ]]; then
     if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
       remote="↑"
     else
       remote="↓"
     fi
   else
     remote=""
   fi
   diverge_pattern="# Your branch and (.*) have diverged"
   if [[ ${git_status} =~ ${diverge_pattern} ]]; then
     remote="↕"
   fi

   # Get the name of the branch.
   branch_pattern="^# On branch ([^${IFS}]*)"
   if [[ ${git_status} =~ ${branch_pattern} ]]; then
     branch=${BASH_REMATCH[1]}
     cut_branch=$(echo $branch| cut -d'_' -f 1)
   fi

   # Set the final branch string.
   BRANCH="${state}(${cut_branch})${remote}${COLOR_NONE} "
 }

 # Return the prompt symbol to use, colorized based on the return value of the
 # previous command.
 function set_prompt_symbol () {
   PROMPT_SYMBOLS="⊖⊚≎∾∿∯∭∲∆≽⋇⋒※⁜⁂₲₱₷❦❇❆✖✪✭❍🙀😱😣😵😅😂ⓣⓉ☢☣☭⚓⚗⚶⚷⌘"
   if test $1 -eq 0 ; then
       PROMPT_SYMBOL=" ⚓"
   else
       PROMPT_SYMBOL="${LIGHT_RED} 😱${COLOR_NONE}"
   fi
   PROMPT_SYMBOL="\h${PROMPT_SYMBOL}"
 }

 # Determine active Python virtualenv details.
 function set_virtualenv () {
   if test -z "$VIRTUAL_ENV" ; then
       PYTHON_VIRTUALENV=""
   else
       PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
   fi
 }
 function PWDN {
   pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
 }
 # Set the full bash prompt.
 function set_bash_prompt () {
   # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
   # return value of the last command.
   set_prompt_symbol $?

   # Set the PYTHON_VIRTUALENV variable.
   set_virtualenv

   # Set the BRANCH variable.
   if is_git_repository ; then
     set_git_branch
   else
     BRANCH=''
   fi
   # Set the bash prompt variable.
   PS1="${PYTHON_VIRTUALENV}${LIGHT_GREEN}\$(PWDN)${COLOR_NONE} ${BRANCH}${PROMPT_SYMBOL}"
 }

 # Tell bash to execute this function just before displaying its prompt.
 PROMPT_COMMAND=set_bash_prompt


export PATH=/usr/local/bin:/usr/local/share/npm/bin:~/bin:$PATH
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export EDITOR='vim'

