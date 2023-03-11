export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export PATH="/usr/local/sbin:$PATH"
export BAT_THEME="ansi"

# THEMES
# Other candidates: simple, sunrise, clean
ZSH_THEME="jbergantine"


# PLUGINS
plugins=(git web-search)
ZSH_DISABLE_COMPFIX="true"
source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/alias-tips/alias-tips.plugin.zsh


# ALIASES
# <<< local aliases <<<
alias zshconfig='vi ~/.zshrc'
alias rld='source ~/.zshrc'
alias size='du -sh * | sort -n | grep G'
alias rd='rm -r'
alias python='python3'
alias pip='pip3'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias hdn='ls -a | grep ^.'
alias tch='touch'
alias rm='trash'
alias rmr='trash-restore'
alias rml='trash-list'
alias ls='lsd --group-dirs first'
alias cat='bat'
# >>> local aliases >>>

# <<< git aliases <<<
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias rbs='git rebase -i'
alias rbsr='git rebase -i --root'
alias gco='git checkout'
alias gl='git log'
# >>> git aliases >>>


# FUNCTIONS
function awsk() {
        echo "[default]\naws_access_key_id = "$1" \naws_secret_access_key = "$2"" > ~/.aws/credentials

}

# PROMPT CONFIG
autoload -U colors && colors # Enable colors in prompt

# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
  [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:' || echo ''
}

# Echoes information about Git repository status when inside a Git repository
git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%{$fg[green]%}⇡NUM%{$reset_color%}"
  local BEHIND="%{$fg[red]%}⇣NUM%{$reset_color%}"
  local REBASING="%{$fg[magenta]%}\uE0A0 %{$reset_color%}"
  local UNTRACKED="%{$fg[red]%}✘%{$reset_color%}"
  local MODIFIED="%{$fg[yellow]%}✘%{$reset_color%}"
  local STAGED="%{$fg[green]%}✘%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS
  local -a GIT_INFO

  GIT_INFO+=( "%{$fg[yellow]%}%B $GIT_LOCATION%{$reset_color%}" )

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/REBASE_HEAD; then
    FLAGS+=( "$REBASING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  echo "${(j: :)GIT_INFO}"

}

# Use ➜ as the non-root prompt character; # for root
# Change the prompt character color if the last command had a nonzero exit code
PS1='%(?.%{$fg[green]%}.%{$fg[red]%})%(!.#.➜) $(ssh_info)%{$fg[blue]%}%1~%u$(git_info)%{$reset_color%} '

# Source fzf and zsh syntax highlighting
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pyenv config
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
