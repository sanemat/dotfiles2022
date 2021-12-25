# github upload
GITHUB_URL_PREFIX="url.git@github.com:"
git config --global --remove-section "$GITHUB_URL_PREFIX" || :
git config --global "$GITHUB_URL_PREFIX".pushInsteadOf "git://github.com/"
git config --global --add "$GITHUB_URL_PREFIX".pushInsteadOf "https://github.com/"
# gist upload
git config --global "url.git@gist.github.com:".pushInsteadOf "https://gist.github.com/$(git config github.user)/"
