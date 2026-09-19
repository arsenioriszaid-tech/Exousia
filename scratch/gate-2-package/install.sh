#!/bin/bash
# Exousia Gate-2 tester installer — EXPERIMENTAL RESEARCH PROTOTYPE, not a product.
# Transparent: this script ONLY copies files into /opt/exousia-g2. No network,
# no telemetry, no auto-update, no system files touched. Revert with uninstall.sh.
set -euo pipefail
[ "$(id -u)" = "0" ] || { echo "Run as root (namespaces + mounts require it)."; exit 1; }
[ "$(uname -s)" = "Linux" ] || { echo "Linux only (needs Landlock + user namespaces)."; exit 1; }
command -v unshare >/dev/null || { echo "Missing: unshare (util-linux)."; exit 1; }
command -v python3 >/dev/null || { echo "Missing: python3."; exit 1; }
SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="/opt/exousia-g2"
echo "Installing Exousia Gate-2 test build to $DEST (files only):"
mkdir -p "$DEST"
for f in agentctl README-TESTER.md uninstall.sh; do
  cp "$SRC/$f" "$DEST/$f" && echo "  + $f"
done
cp "$SRC/policy-default.json" "$DEST/policy.json" && echo "  + policy.json (from policy-default.json)"
mkdir -p "$DEST/plugin-template" && cp "$SRC/plugin-template/exousia-gate.js" "$DEST/plugin-template/" && echo "  + plugin-template/exousia-gate.js"
chmod +x "$DEST/agentctl" "$DEST/uninstall.sh"
ln -sf "$DEST/agentctl" /usr/local/bin/exousia-g2 2>/dev/null || true
echo
echo "Done. Verify: exousia-g2 verify (fresh audit) — then read $DEST/README-TESTER.md"
echo "BEFORE running anything on real work: use a NON-SENSITIVE test repo only."
echo "Remove any time with: $DEST/uninstall.sh"
