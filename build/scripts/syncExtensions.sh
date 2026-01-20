#!/usr/bin/env sh
# Synchronize Drupal extensions (modules and themes) to match core.extension.yml.
echo "Sync Extensions : Synchronizing modules and themes..."

# Gets items in list1 but not in list2 (space-separated)
diff_lists() {
  LIST1="$1"
  LIST2="$2"
  RESULT=""
  for item in $LIST1; do
    [ -z "$item" ] && continue
    FOUND=0
    for check in $LIST2; do
      if [ "$item" = "$check" ]; then
        FOUND=1
        break
      fi
    done
    if [ "$FOUND" -eq 0 ]; then
      RESULT="$RESULT $item"
    fi
  done
  echo "$RESULT" | xargs
}

# Gets if item exists in list
list_contains() {
  ITEM="$1"
  LIST="$2"
  for check in $LIST; do
    if [ "$ITEM" = "$check" ]; then
      return 0
    fi
  done
  return 1
}

# Removes item from list
remove_from_list() {
  ITEM="$1"
  LIST="$2"
  RESULT=""
  for check in $LIST; do
    if [ "$ITEM" != "$check" ]; then
      RESULT="$RESULT $check"
    fi
  done
  echo "$RESULT" | xargs
}

# Function: Handle theme setting change (default or admin)
# Updates the theme setting and installs the new theme if needed.
# Does NOT uninstall old themes - that's handled by the bulk uninstall phase.
# Args: $1=setting_name (default|admin)
handle_theme_setting_change() {
  SETTING_NAME="$1"
  CURRENT_VALUE=$(${DRUSH} config:get system.theme "$SETTING_NAME" --format=string 2>/dev/null)
  TARGET_VALUE=$(yq eval ".$SETTING_NAME" "$SYSTEM_THEME_FILE" 2>/dev/null)
  # Note: yq returns literal "null" string for missing keys, not empty
  [ "$TARGET_VALUE" = "null" ] && TARGET_VALUE=""

  # No change needed
  [ -z "$CURRENT_VALUE" ] && return 0
  [ -z "$TARGET_VALUE" ] && return 0
  [ "$CURRENT_VALUE" = "$TARGET_VALUE" ] && return 0

  echo "Sync Extensions : ${SETTING_NAME} theme changing from '$CURRENT_VALUE' to '$TARGET_VALUE'"

  if list_contains "$TARGET_VALUE" "$THEMES_TO_INSTALL"; then
    echo "Sync Extensions : Installing new ${SETTING_NAME} theme: $TARGET_VALUE"
    ${DRUSH} theme:install "$TARGET_VALUE" || {
      echo "Sync Extensions : ERROR - Failed to install ${SETTING_NAME} theme: $TARGET_VALUE"
      exit 1
    }
    # Remove from install list since we just installed it
    THEMES_TO_INSTALL=$(remove_from_list "$TARGET_VALUE" "$THEMES_TO_INSTALL")
    echo "$THEMES_TO_INSTALL" > /tmp/themes_to_install.tmp
  fi

  echo "Sync Extensions : Setting ${SETTING_NAME} theme to: $TARGET_VALUE"
  ${DRUSH} config:set system.theme "$SETTING_NAME" "$TARGET_VALUE" || {
    echo "Sync Extensions : ERROR - Failed to set ${SETTING_NAME} theme: $TARGET_VALUE"
    exit 1
  }
}

### MODULES
CURRENT_MODULES=$(/scripts/getEnabledProjects.sh module | tr '\n' ' ')
TARGET_MODULES=$(/scripts/getStagedProjects.sh module | tr '\n' ' ')
MODULES_TO_UNINSTALL=$(diff_lists "$CURRENT_MODULES" "$TARGET_MODULES")
MODULES_TO_INSTALL=$(diff_lists "$TARGET_MODULES" "$CURRENT_MODULES")

### THEMES
CURRENT_THEMES=$(/scripts/getEnabledProjects.sh theme | tr '\n' ' ')
TARGET_THEMES=$(/scripts/getStagedProjects.sh theme | tr '\n' ' ')

THEMES_TO_UNINSTALL=$(diff_lists "$CURRENT_THEMES" "$TARGET_THEMES")
THEMES_TO_INSTALL=$(diff_lists "$TARGET_THEMES" "$CURRENT_THEMES")

### THEME SETTINGS HANDLING
# Handle theme setting changes BEFORE bulk uninstall/install phases.
# This ensures the new theme is installed and set before we try to uninstall
# the old theme (which may be the current default or admin).
SYSTEM_THEME_FILE="$DRUPAL_CONFIGURATION_DIR/system.theme.yml"
if [ -f "$SYSTEM_THEME_FILE" ]; then
  handle_theme_setting_change "default"
  # Check if install list was modified
  [ -f /tmp/themes_to_install.tmp ] && {
    THEMES_TO_INSTALL=$(cat /tmp/themes_to_install.tmp)
    rm -f /tmp/themes_to_install.tmp
  }

  handle_theme_setting_change "admin"
  # Check if install list was modified
  [ -f /tmp/themes_to_install.tmp ] && {
    THEMES_TO_INSTALL=$(cat /tmp/themes_to_install.tmp)
    rm -f /tmp/themes_to_install.tmp
  }
fi

### UNINSTALL PHASE
if [ -n "$MODULES_TO_UNINSTALL" ]; then
  echo "Sync Extensions : Uninstalling modules: $MODULES_TO_UNINSTALL"
  ${DRUSH} pm:uninstall $MODULES_TO_UNINSTALL || {
    echo "Sync Extensions : ERROR - Failed to uninstall modules"
    exit 1
  }
else
  echo "Sync Extensions : No modules to uninstall."
fi

if [ -n "$THEMES_TO_UNINSTALL" ]; then
  echo "Sync Extensions : Uninstalling themes: $THEMES_TO_UNINSTALL"
  ${DRUSH} theme:uninstall $THEMES_TO_UNINSTALL || {
    echo "Sync Extensions : ERROR - Failed to uninstall themes"
    exit 1
  }
else
  echo "Sync Extensions : No themes to uninstall."
fi

### INSTALL PHASE
if [ -n "$MODULES_TO_INSTALL" ]; then
  echo "Sync Extensions : Installing modules: $MODULES_TO_INSTALL"
  ${DRUSH} en $MODULES_TO_INSTALL || {
    echo "Sync Extensions : ERROR - Failed to install modules"
    exit 1
  }
else
  echo "Sync Extensions : No modules to install."
fi

if [ -n "$THEMES_TO_INSTALL" ]; then
  echo "Sync Extensions : Installing themes: $THEMES_TO_INSTALL"
  ${DRUSH} theme:install $THEMES_TO_INSTALL || {
    echo "Sync Extensions : ERROR - Failed to install themes"
    exit 1
  }
else
  echo "Sync Extensions : No themes to install."
fi

echo "Sync Extensions : Extension synchronization complete."
