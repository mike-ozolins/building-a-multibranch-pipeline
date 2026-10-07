#!/usr/bin/env sh
set -eu

echo 'The following "npm" command runs your Node.js/React application in'
echo 'development mode and makes the application available for web browsing.'
echo 'The "npm start" command has a trailing ampersand so that the command runs'
echo 'as a background process (i.e. asynchronously). Otherwise, this command'
echo 'can pause running builds of CI/CD applications indefinitely. "npm start"'
echo 'is followed by another command that retrieves the process ID (PID) value'
echo 'of the previously run process (i.e. "npm start") and writes this value to'
echo 'the file ".pidfile".'

PORT=3000
if ss -lnt | awk '{print $4}' | grep -Eq '(:3000)$'; then
    PORT=3001
fi
if ss -lnt | awk '{print $4}' | grep -Eq "(:${PORT})$"; then
    PORT=3002
fi

if [ -f .pidfile ]; then
    OLD_PID=$(cat .pidfile 2>/dev/null || true)
    if [ -n "${OLD_PID}" ] && kill -0 "${OLD_PID}" 2>/dev/null; then
        echo "Stopping previous app process ${OLD_PID}"
        kill "${OLD_PID}" || true
    fi
fi

set -x
PORT="${PORT}" npm start &
echo $! > .pidfile
set +x

echo 'Now...'
echo "Visit http://localhost:${PORT} to see your Node.js/React application in action."
echo 'The app is starting on a free port to avoid collisions with other services already using 3000.'
