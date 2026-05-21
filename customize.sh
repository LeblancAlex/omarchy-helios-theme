#!/usr/bin/env bash
#
# customize.sh — Retune all theme colors from a single source of truth.
#
# Edit the variables in the CURRENT (sun) and TARGET (your tweak) sections,
# then run:  ./customize.sh
#
# This script does a literal find-and-replace across all theme config files.
# It's idempotent as long as you keep CURRENT in sync with the current state
# of the files (i.e. after running, update CURRENT to match TARGET before
# the next tweak).
#
# Tip: To change just the highlight color, only edit ACCENT_BRIGHT in TARGET.

set -euo pipefail

# ---- CURRENT palette (what's in the files right now) -----------------------
CURRENT_BG="#000000"          # space black
CURRENT_FG="#F5E1A4"          # solar cream
CURRENT_ACCENT_BRIGHT="#FFB938"  # solar flare (cursor / highlight)
CURRENT_ACCENT_HI="#F4C430"      # saffron
CURRENT_ACCENT_MID="#E8A33D"     # amber
CURRENT_ACCENT_DEEP="#B0741F"    # burnt amber
CURRENT_BORDER="#8B6F2B"         # muted gold
CURRENT_SELECTION_BG="#4A3818"   # dark amber
CURRENT_PANEL_BG="#2A1F0A"       # deep amber (mako / walker / swayosd bg)
CURRENT_CHROMIUM_RGB="42,31,10"  # decimal of CURRENT_PANEL_BG

# Hyprlock uses decimal RGB tuples; keep these aligned with the hex values above.
CURRENT_HYPRLOCK_INNER="rgba(42, 31, 10, 0.8)"        # = CURRENT_PANEL_BG
CURRENT_HYPRLOCK_OUTER="rgba(245, 225, 164, 1.0)"     # = CURRENT_FG
CURRENT_HYPRLOCK_FONT="rgba(245, 225, 164, 1.0)"      # = CURRENT_FG
CURRENT_HYPRLOCK_CHECK="rgba(255, 185, 56, 1.0)"      # = CURRENT_ACCENT_BRIGHT

# ---- TARGET palette (edit these, then run the script) ----------------------
TARGET_BG="$CURRENT_BG"
TARGET_FG="$CURRENT_FG"
TARGET_ACCENT_BRIGHT="$CURRENT_ACCENT_BRIGHT"
TARGET_ACCENT_HI="$CURRENT_ACCENT_HI"
TARGET_ACCENT_MID="$CURRENT_ACCENT_MID"
TARGET_ACCENT_DEEP="$CURRENT_ACCENT_DEEP"
TARGET_BORDER="$CURRENT_BORDER"
TARGET_SELECTION_BG="$CURRENT_SELECTION_BG"
TARGET_PANEL_BG="$CURRENT_PANEL_BG"
TARGET_CHROMIUM_RGB="$CURRENT_CHROMIUM_RGB"

TARGET_HYPRLOCK_INNER="$CURRENT_HYPRLOCK_INNER"
TARGET_HYPRLOCK_OUTER="$CURRENT_HYPRLOCK_OUTER"
TARGET_HYPRLOCK_FONT="$CURRENT_HYPRLOCK_FONT"
TARGET_HYPRLOCK_CHECK="$CURRENT_HYPRLOCK_CHECK"

# ---- Apply -----------------------------------------------------------------
cd "$(dirname "$0")"

FILES=(
  alacritty.toml
  btop.theme
  chromium.theme
  ghostty.conf
  hyprland.conf
  hyprlock.conf
  mako.ini
  swayosd.css
  walker.css
  waybar.css
)

# Helper: hex like "#FFB938" -> ALL forms used in configs (with #, lowercase no-#, rgba prefix)
replace_hex() {
  local from="$1" to="$2"
  local from_lc="${from,,}" to_lc="${to,,}"
  local from_uc="${from^^}" to_uc="${to^^}"
  local from_nohash="${from#\#}" to_nohash="${to#\#}"
  for f in "${FILES[@]}"; do
    [ -f "$f" ] || continue
    sed -i \
      -e "s/${from}/${to}/g" \
      -e "s/${from_lc}/${to_lc}/g" \
      -e "s/${from_uc}/${to_uc}/g" \
      -e "s/${from_nohash}ff/${to_nohash}ff/g" \
      "$f"
  done
}

replace_literal() {
  local from="$1" to="$2"
  for f in "${FILES[@]}"; do
    [ -f "$f" ] || continue
    # Use a delimiter unlikely to appear in CSS colors
    sed -i "s|${from}|${to}|g" "$f"
  done
}

replace_hex     "$CURRENT_BG"            "$TARGET_BG"
replace_hex     "$CURRENT_FG"            "$TARGET_FG"
replace_hex     "$CURRENT_ACCENT_BRIGHT" "$TARGET_ACCENT_BRIGHT"
replace_hex     "$CURRENT_ACCENT_HI"     "$TARGET_ACCENT_HI"
replace_hex     "$CURRENT_ACCENT_MID"    "$TARGET_ACCENT_MID"
replace_hex     "$CURRENT_ACCENT_DEEP"   "$TARGET_ACCENT_DEEP"
replace_hex     "$CURRENT_BORDER"        "$TARGET_BORDER"
replace_hex     "$CURRENT_SELECTION_BG"  "$TARGET_SELECTION_BG"
replace_hex     "$CURRENT_PANEL_BG"      "$TARGET_PANEL_BG"
replace_literal "$CURRENT_CHROMIUM_RGB"  "$TARGET_CHROMIUM_RGB"
replace_literal "$CURRENT_HYPRLOCK_INNER" "$TARGET_HYPRLOCK_INNER"
replace_literal "$CURRENT_HYPRLOCK_OUTER" "$TARGET_HYPRLOCK_OUTER"
replace_literal "$CURRENT_HYPRLOCK_FONT"  "$TARGET_HYPRLOCK_FONT"
replace_literal "$CURRENT_HYPRLOCK_CHECK" "$TARGET_HYPRLOCK_CHECK"

echo "Done. Don't forget to update the CURRENT_* variables in this script"
echo "to match the new values before the next run."
