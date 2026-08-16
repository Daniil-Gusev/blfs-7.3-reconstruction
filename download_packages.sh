#!/usr/bin/env bash
set -uo pipefail

declare -A CSV_DIR_MAP=(
  ["main-packages.csv"]="main-packages"
  ["perl-modules.csv"]="perl-modules"
  ["python-packages.csv"]="python-packages"
  ["xorg-packages.csv"]="xorg-packages"
)

LOGFILE="$(pwd)/download.log"
: > "$LOGFILE"

log_error() {
  echo "$(date -Iseconds) $1" >> "$LOGFILE"
}

for csv in "${!CSV_DIR_MAP[@]}"; do
  dir="${CSV_DIR_MAP[$csv]}"

  if [ ! -f "$csv" ]; then
    echo "[$csv] file not found"
    log_error "[$csv] csv file not found"
    continue
  fi

  mkdir -p "$dir"

  while IFS=',' read -r filename url md5sum_expected sha256sum_expected; do
    [ "$filename" = "filename" ] && continue
    [ -z "$filename" ] && continue

    echo "[$csv] downloading $filename"
    dest="$dir/$filename"

    if ! curl -fsS --retry 5 --retry-delay 3 --retry-connrefused -o "$dest" "$url"; then
      echo "[$csv] $filename FAILED (download error)"
      log_error "[$csv] $filename download failed url=$url"
      continue
    fi

    if [ -n "$md5sum_expected" ]; then
      actual_md5=$(md5sum "$dest" | awk '{print $1}')
      if [ "$actual_md5" != "$md5sum_expected" ]; then
        echo "[$csv] $filename FAILED (md5 mismatch)"
        log_error "[$csv] $filename md5 mismatch expected=$md5sum_expected actual=$actual_md5"
      fi
    fi

    if [ -n "$sha256sum_expected" ]; then
      actual_sha256=$(sha256sum "$dest" | awk '{print $1}')
      if [ "$actual_sha256" != "$sha256sum_expected" ]; then
        echo "[$csv] $filename FAILED (sha256 mismatch)"
        log_error "[$csv] $filename sha256 mismatch expected=$sha256sum_expected actual=$actual_sha256"
      fi
    fi
  done < "$csv"
done

echo "Done. See $LOGFILE for errors."
