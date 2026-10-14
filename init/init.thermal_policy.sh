#! /vendor/bin/sh
#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

conf_file="/vendor/etc/.tp/thermal.policy.conf"
thermal="/sys/class/thermal"

zone_path() {
  for tz in $thermal/thermal_zone*; do
    [ "$(cat $tz/type)" = "$1" ] && echo $tz && return
  done
}

cdev_path() {
  for cd in $thermal/cooling_device*; do
    [ "$(cat $cd/type)" = "$1" ] && echo $cd && return
  done
}

write_trips() {
  i=0
  for value in $2; do
    echo $value > $1/trip_point_${i}_$3
    i=$((i + 1))
  done
}

apply_zone() {
  tz=$(zone_path $zone)
  [ -z "$tz" ] && return

  bound=""
  for cdev in $cdevs; do
    [ -n "$(cdev_path $cdev)" ] && bound="$bound $cdev"
  done
  [ -z "$bound" ] && return

  set -- $trips
  if [ "$(cat $tz/trips)" != "$#" ]; then
    log -t thermal_policy "$zone: expected $(cat $tz/trips) trips, policy has $#"
    return
  fi

  [ -n "$gov" ] && echo $gov > $tz/policy
  write_trips $tz "$trips" temp
  write_trips $tz "$hyst" hyst

  id=${tz##*thermal_zone}
  echo "$levels" | while read -r cdev states; do
    case " $bound " in
      *" $cdev "*) ;;
      *) continue ;;
    esac
    cd=$(cdev_path $cdev)
    trip=0
    for state in $states; do
      echo "$trip $state $id" > $cd/levels
      trip=$((trip + 1))
    done
  done

  [ -n "$poll" ] && echo $poll > $tz/polling
  log -t thermal_policy "$zone: bound$bound"
}

[ -f $conf_file ] || exit 0

while read -r key value; do
  case $key in
    "[") zone="" gov="" cdevs="" trips="" hyst="" poll="" levels="" ;;
    "]") apply_zone ;;
    zone) zone=$value ;;
    gov) gov=$value ;;
    cdevs) cdevs=$value ;;
    trip) trips=$value ;;
    hyst) hyst=$value ;;
    poll) poll=$value ;;
    *)
      case " $cdevs " in
        *" $key "*) levels="$levels$key $value
" ;;
      esac
      ;;
  esac
done < $conf_file
