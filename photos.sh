#!/usr/bin/env bash
# Resizes the owner's (already watermarked) photos for the web.
#
#   photos/<SKU>.jpg|jpeg|png|webp|heic  →  web/img/<SKU>.jpg  (+ web/img/index.json)
#
# The page shows web/img/<SKU>.jpg for any product whose INVENTORY Photo cell
# is blank. Re-running only redoes changed photos; FORCE=1 redoes all.
# Settings: SIZE (longest edge, px, default 1000), QUALITY (JPEG, default 80).
set -euo pipefail
cd "$(dirname "$0")"

SRC=photos
OUT=web/img
SIZE=${SIZE:-1000}
QUALITY=${QUALITY:-80}

if command -v magick >/dev/null; then IM=(magick)
elif command -v convert >/dev/null; then IM=(convert)
else
  echo "ImageMagick is not installed. Install it with: sudo apt install imagemagick (macOS: brew install imagemagick)" >&2
  exit 1
fi
[[ -d $SRC ]] || { echo "Put the photos in $SRC/ first, named <SKU>.jpg" >&2; exit 1; }

mkdir -p "$OUT"
shopt -s nullglob nocaseglob
declare -A keep=()
entries=()
for f in "$SRC"/*.{jpg,jpeg,png,webp,heic,heif}; do
  sku=$(basename "${f%.*}")
  if [[ ! $sku =~ ^[A-Za-z0-9._-]+$ ]]; then
    echo "skipping $f: name it exactly like its SKU (letters, digits, . _ - only)" >&2
    continue
  fi
  if [[ -n ${keep[$sku.jpg]:-} ]]; then
    echo "skipping $f: there is another photo for $sku" >&2
    continue
  fi
  out="$OUT/$sku.jpg"
  if [[ -n ${FORCE:-} || ! -e $out || $f -nt $out ]]; then
    # -auto-orient applies the phone's rotation; -strip drops EXIF (incl. GPS location).
    "${IM[@]}" "$f" -auto-orient -resize "${SIZE}x${SIZE}>" -background white -flatten \
      -strip -sampling-factor 4:2:0 -interlace JPEG -quality "$QUALITY" "$out"
    echo "  wrote $out"
  fi
  keep[$sku.jpg]=1
  entries+=("  \"$sku\": \"$sku.jpg?v=$(sha1sum "$out" | cut -c1-8)\"")
done

removed=0
for o in "$OUT"/*.jpg; do
  if [[ -z ${keep[$(basename "$o")]:-} ]]; then rm -- "$o"; removed=$((removed + 1)); fi
done

{
  echo "{"
  for i in "${!entries[@]}"; do
    if (( i < ${#entries[@]} - 1 )); then echo "${entries[$i]},"; else echo "${entries[$i]}"; fi
  done
  echo "}"
} > "$OUT/index.json"

echo "${#entries[@]} photos in $OUT ($(du -sh "$OUT" | cut -f1)), $removed old ones removed."
