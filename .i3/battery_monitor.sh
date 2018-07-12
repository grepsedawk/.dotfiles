#! /usr/bin/env bash

SLEEP_TIME=5   # Default time between checks.
SAFE_PERCENT=30  # Still safe at this level.
DANGER_PERCENT=20  # Warn when battery at this level.
CRITICAL_PERCENT=5  # Hibernate when battery at this level.

NAGBAR_PID=0
export DISPLAY=:0.0

function launchNagBar
{
  ps -p $NAGBAR_PID 2> /dev/null | grep "i3-nagbar" &> /dev/null

  if [ $? -ne 0 ]; then
    i3-nagbar -m 'Battery low!' -b 'Suspend!' 'systemctl suspend' &> /dev/null &
  fi
  NAGBAR_PID=$!
}

function killNagBar
{
  if [[ $NAGBAR_PID -ne 0 ]]; then
        ps -p $NAGBAR_PID 2> /dev/null | grep "i3-nagbar" &> /dev/null
        if [[ $? -eq 0 ]]; then
            kill $NAGBAR_PID
        fi
        NAGBAR_PID=0
  fi
}


while [ true ]; do
    if [[ -n $(acpi -b | grep -i discharging) ]]; then
        rem_bat=$(acpi -b | grep -Eo "[0-9]+%" | grep -Eo "[0-9]+")

        if [[ $rem_bat -gt $SAFE_PERCENT ]]; then
            SLEEP_TIME=10
        else
            SLEEP_TIME=5
            if [[ $rem_bat -le $DANGER_PERCENT ]]; then
                SLEEP_TIME=2
                launchNagBar
            fi
            if [[ $rem_bat -le $CRITICAL_PERCENT ]]; then
                SLEEP_TIME=1
                systemctl suspend
            fi
        fi
    else
        killNagBar
        SLEEP_TIME=30
    fi

    sleep ${SLEEP_TIME}

done
