#!/usr/bin/env sh
while getopts ":s" OPT; do
  case $OPT in
    s)
      DRUSH_ARGS='-- --security'
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

drush --root=/app/html --yes scr /scripts/getDrupalUpdates.php $DRUSH_ARGS
