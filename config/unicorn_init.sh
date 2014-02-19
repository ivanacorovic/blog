

    Explore
    Gist
    Blog
    Help

    ivanacorovic ivanacorovic

    4
    27
    19

public railscasts / 335-deploying-to-a-vps

335-deploying-to-a-vps / blog-nginx / config / unicorn_init.sh
Ryan Bates ryanb 2 years ago
automatic import from ryanb/railscasts-episodes

1 contributor
executable file 85 lines (77 sloc) 1.744 kb
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 	

#!/bin/sh
### BEGIN INIT INFO
# Provides: unicorn
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Manage unicorn server
# Description: Start, stop, restart unicorn server for a specific application.
### END INIT INFO
set -e

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT=/home/deployer/capistrano/current
PID=$APP_ROOT/tmp/pids/unicorn.pid
CMD="cd $APP_ROOT; bundle exec unicorn -D -c $APP_ROOT/config/unicorn.rb -E production"
AS_USER=deployer
set -u

OLD_PIN="$PID.oldbin"

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $OLD_PIN && kill -$1 `cat $OLD_PIN`
}

run () {
  if [ "$(id -un)" = "$AS_USER" ]; then
eval $1
  else
su -c "$1" - $AS_USER
  fi
}

case "$1" in
start)
  sig 0 && echo >&2 "Already running" && exit 0
  run "$CMD"
  ;;
stop)
  sig QUIT && exit 0
  echo >&2 "Not running"
  ;;
force-stop)
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
restart|reload)
  sig HUP && echo reloaded OK && exit 0
  echo >&2 "Couldn't reload, starting '$CMD' instead"
  run "$CMD"
  ;;
upgrade)
  if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
  then
n=$TIMEOUT
    while test -s $OLD_PIN && test $n -ge 0
    do
printf '.' && sleep 1 && n=$(( $n - 1 ))
    done
echo

if test $n -lt 0 && test -s $OLD_PIN
    then
echo >&2 "$OLD_PIN still exists after $TIMEOUT seconds"
      exit 1
    fi
exit 0
  fi
echo >&2 "Couldn't upgrade, starting '$CMD' instead"
  run "$CMD"
  ;;
reopen-logs)
  sig USR1
  ;;
*)
  echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
  exit 1
  ;;
esac

    Status
    API
    Training
    Shop
    Blog
    About

    © 2014 GitHub, Inc.
    Terms
    Privacy
    Security
    Contact

