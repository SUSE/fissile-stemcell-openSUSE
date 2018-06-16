#!/bin/bash
set -o errexit -o xtrace
# Cannot use this generally. Interferes with the check via `monit summary`.
# I.e. when things are ready the failure of grep to match aborts us.

# Check for post-start scripts to run. We may not have any.
#
# * `flock` is used to guard against monit starting this script
#   multiple times when our dependency checking and/or the invoked
#   scripts are taking too long.
#
# * `monit summary` is used to check if the __other__ jobs are up.
#   Nothing is done while they are not up yet. We know that we are
#   `post-start`, important to exclude ourselves from the check
#
# Doing our own dependency checking works around issues in monit.
# This can be shifted to monit itself ('depends on') when we reach use
# of monit v5.15+ where the issues are fixed.

(
  exec  >/proc/1/fd/1
  exec 2>/proc/1/fd/2
  flock -n 9 || exit 1

  summary="$(/var/vcap/bosh/bin/monit summary)" # Separate to capture exit status
  if printf "%s" "${summary}" | tail -n+3 | grep -v post-start | grep --silent -viw 'accessible\|running'
  then
    # Other roles not ready, wait a bit more without returning error
    exit 0
  fi

  while read -r f ; do
    echo bash "$f"
    bash "$f"
  done < <(find /var/vcap/jobs/*/bin -name post-start)
  touch /var/vcap/monit/ready

) 9> /var/vcap/monit/ready.lock
