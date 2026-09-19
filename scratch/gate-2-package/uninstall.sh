#!/bin/bash
# Removes ONLY what install.sh created. Nothing else is touched.
set -euo pipefail
[ "$(id -u)" = "0" ] || { echo "Run as root."; exit 1; }
rm -rf /opt/exousia-g2 /usr/local/bin/exousia-g2
echo "Removed /opt/exousia-g2 and the exousia-g2 symlink."
echo "Note: per-run sandbox dirs (/g1work, /g1run, /g1audit) are host dirs created"
echo "by test runs. Inspect then remove manually if desired: rm -rf /g1work /g1run /g1audit /g1secrets"
