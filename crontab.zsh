# crontab -l
# http://d.hatena.ne.jp/anatoo/20120424/1335198888
# * * * * * /bin/echo 'display notification "Sit up straight" with title "Cron Jedi"' | /usr/bin/osascript
# * * * * * DISPLAY=:0.0 /usr/bin/notify-send "Cron Jedi" "Sit up straight"
# http://stackoverflow.com/questions/610839/how-can-i-programmatically-create-a-new-cron-job
case "$OSTYPE" in
  darwin*)
    (crontab -l ; echo '* * * * * /bin/echo '\''display notification "Sit up straight" with title "Cron Jedi"'\'' | /usr/bin/osascript') | sort - | uniq - | crontab -
  ;;
  linux*)
    # If their is no crontab, then it will fail.
    (crontab -l ; echo '* * * * * DISPLAY=:0.0 /usr/bin/notify-send -u "critical" "Cron Jedi" "Sit up straight"') | sort - | uniq - | crontab -
  ;;
  dragonfly*|freebsd*|netbsd*|openbsd*)
    # ...
  ;;
esac
