# _LOCAL_ZPROFILE="$HOME/go/src/github.com/sanemat22/zprofile"
# if [ -f "$_LOCAL_ZPROFILE" ]; then
#   echo "load $_LOCAL_ZPROFILE"
#   . $_LOCAL_ZPROFILE
# fi

# copied from /etc/zprofile
# system-wide environment settings for zsh(1)
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
fi