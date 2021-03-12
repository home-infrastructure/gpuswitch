#!/usr/bin/env bash

# determine current mode
CURRENT_MODE=$(readlink -f "/etc/nixos/hosts/thinkpad/graphical-mode.nix" | xargs basename | sed 's,graphical-,,' | sed 's,\.nix,,')

# check if flags provided
if [ $# -eq 0 ]; then
  # print current mode
  echo "Current Mode: ${CURRENT_MODE}"
else
  # ensure new mode is valid
  if [ -f "/etc/nixos/hosts/thinkpad/templates/graphical-${1}.nix" ]; then
    # write out plan
    echo "Switching from ${CURRENT_MODE} to ${1}..."

    # symlink in new mode
    ln -s -f "/etc/nixos/hosts/thinkpad/templates/graphical-${1}.nix" "/etc/nixos/hosts/thinkpad/graphical-mode.nix"

    # rebuild system to apply change (without --upgrade to avoid needing internet access)
    nixos-rebuild switch

    # restart X11 (use screen, detach and exit once command complete)
    screen -d -m bash -c '/run/current-system/sw/bin/systemctl restart display-manager.service'
  else
    echo "There is no graphical mode named: ${1}"
    exit 1
  fi
fi
