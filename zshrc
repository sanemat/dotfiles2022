# _LOCAL_ZSHRC="$HOME/go/src/github.com/sanemat/dotfiles2022/zshrc"
# if [ -f "$_LOCAL_ZSHRC" ]; then
#   echo "load $_LOCAL_ZSHRC"
#   . $_LOCAL_ZSHRC
# fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

## command completion
zinit ice wait'0'; zinit light zsh-users/zsh-completions

## case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## can move with tab
zstyle ':completion:*:default' menu select=1

# syntax highlighting
zinit ice wait'0'; zinit light zsh-users/zsh-syntax-highlighting

# suggestions
zinit ice wait'0'; zinit light zsh-users/zsh-autosuggestions

# in ~/.zshenv, executed `unsetopt GLOBAL_RCS` and ignored /etc/zshrc
[ -r /etc/zshrc ] && . /etc/zshrc
[ -r /etc/zsh/zshrc ] && . /etc/zsh/zshrc

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export PATH
export MANPATH
# -U: keep only the first occurrence of each duplicated value
# ref. http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html#index-typeset
typeset -U PATH path MANPATH manpath

export GOPATH="$HOME/go"

path=(
  ${HOME}/bin(N-/)
  ${HOME}/.ghg/bin(N-/)
  ${GOPATH}/bin(N-/)
  ${HOME}/.cargo/bin(N-/)
  ${HOME}/Android/Sdk/tools(N-/)
  ${HOME}/Android/Sdk/tools/bin(N-/)
  ${HOME}/Android/Sdk/platform-tools(N-/)
  ${GOPATH}/src/chromium.googlesource.com/chromium/tools/depot_tools(N-/)
  ${HOME}/homebrew/bin(N-/)
  ${HOME}/homebrew/sbin(N-/)
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin(N-/)
  ${path}
)

manpath=(
  ${HOME}/homebrew/share/man(N-/)
  ${manpath}
)

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

zinit ice silent as"completion"
zinit snippet https://raw.githubusercontent.com/x-motemen/ghq/master/misc/zsh/_ghq

# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# Save command history
export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history no_inc_append_history no_share_history

# prompt
export PS1="${debian_chroot:+($debian_chroot)}\$ "

ASDF_CONFIG_FILE="$HOME/go/src/github.com/sanemat/dotfiles2022/asdfrc"

fpath=(${ASDF_DIR}/completions $fpath)

alias g='cd $(ghq root)/$(ghq list | fzf --reverse)'

export ASDF_GOLANG_MOD_VERSION_ENABLED=true

# . "$HOME/.asdf/asdf.sh"
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml"

eval "$(ssh-agent -s)"
