# _LOCAL_ZSHENV="$HOME/go/src/github.com/sanemat/dotfiles2019/zshenv"
# if [ -f "$_LOCAL_ZSHENV" ]; then
#   echo "load $_LOCAL_ZSHENV"
#   . $_LOCAL_ZSHENV
# fi

# ignore /etc/zprofile, /etc/zshrc, /etc/zlogin, and /etc/zlogout
# ref. http://zsh.sourceforge.net/Doc/Release/Files.html
# ref. http://zsh.sourceforge.net/Doc/Release/Options.html#index-GLOBALRCS
unsetopt GLOBAL_RCS