#!/bin/bash

LAYOUTS_DIR="$HOME/.config/i3/layouts"
# ToDo:= Select layout based on date... by now only work layout
SEL_LAYOUT="work"
SEL_LAYOUT_CFG="${LAYOUTS_DIR}/${SEL_LAYOUT}/config"

if [[ ! -f "${SEL_LAYOUT_CFG}" ]]; then
  echo "Enoent ${SEL_LAYOUT_CFG}"
  exit 0
else
  source "${SEL_LAYOUT_CFG}"
fi

# globals:
#   WORKTIME_DAYS (array)
#   WORKTIME_HOURS (array)
check_layout_in_time() {
  local work_from=${WORKTIME_HOURS[0]}
  local work_to=${WORKTIME_HOURS[1]}
  local current_day=$(date +"%u")
  local current_hour=$(date +"%H")
  if [[ " ${WORKTIME_DAYS[@]} " =~ " ${current_day} " ]]; then
    if [[ "${current_hour}" -ge "${work_from}" && "${current_hour}" -lt "${work_to}" ]]; then
      return
    fi
  fi
  false
}

# arguments:
#   workspace_id (int)
# globals:
#   COMMANDS (array)
#   WORKSPACE_RESTORE (bool)
launch_workspace() {
  local workspace_id=$1; shift
  local workspace_file="${LAYOUTS_DIR}/${SEL_LAYOUT}/workspace_${workspace_id}.json"
  local workspace_commands="${LAYOUTS_DIR}/${SEL_LAYOUT}/workspace_${workspace_id}.config"
  if [[ ! -f "${workspace_commands}" ]]; then
    false
    return
  fi
  source "${workspace_commands}"
  if [[ -f "${workspace_file}" ]]; then
    i3msg_str="workspace ${workspace_id}"
    if [[ -z "${WORKSPACE_RESTORE}" || "${WORKSPACE_RESTORE}" == true ]]; then
      echo "restoring $WORKSPACE_RESTORE"
      i3msg_str+="; append_layout ${workspace_file}"
    fi
    echo "$i3msg_str"
    i3-msg "${i3msg_str}" >/dev/null
    for command in "${COMMANDS[@]}"; do
      echo "--> Launching command ${command}"
      # horrible hack
      eval $command 2>/dev/null &
    done
  fi
}

if check_layout_in_time; then
  echo "Should launch $SEL_LAYOUT layout"
  for workspace_id in "${WORKSPACES[@]}"; do
    echo "-> Launching workspace $workspace_id"
    launch_workspace $workspace_id
    sleep 2s;
  done
else
  echo "Should launch nothing"
fi
