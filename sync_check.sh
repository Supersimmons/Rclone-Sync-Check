#!/bin/sh

# Paths
src="/data/data/com.termux/files/home/storage/dcim/Camera"
dest="remote:bucket/path"  # or any S3-compatible remote path
tmpdir="$HOME/.tmp_rclone_check"
mkdir -p "$tmpdir"

echo "⏳ Scanning files..."

# Local Android counters
local_count=$(find "$src" -type f ! -name ".trashed-*" | wc -l)
local_size=$(find "$src" -type f ! -name ".trashed-*" -exec stat -c %s {} + | awk '{sum+=$1} END{print sum}')

# Check if remote directory exists
if ! rclone lsf "$dest" >/dev/null 2>&1; then
  echo "❌ The directory $dest does not exist or is not accessible on the remote."
  exit 1
fi

# Remote info in JSON
json=$(rclone size "$dest" --json)
remote_count=$(echo "$json" | grep -o '"count":[0-9]*' | cut -d: -f2)
remote_size=$(echo "$json" | grep -o '"bytes":[0-9]*' | cut -d: -f2)

# Print stats
echo ""
echo "📱 On Android:"
echo "  File count: $local_count"
echo "  Used space: $local_size B"

echo "☁️ On remote (S3-compatible):"
echo "  File count: $remote_count"
echo "  Used space: $remote_size B"

# Basic comparison
[ "$local_count" != "$remote_count" ] && echo "⚠️ WARNING: File count does not match!"
[ "$local_size" != "$remote_size" ] && echo "⚠️ WARNING: Storage usage does not match!"

# Compare file names and sizes
echo ""
echo "📋 Comparing local vs remote files (name and size)..."
find "$src" -type f ! -name ".trashed-*" | while read -r filepath; do
  relpath="${filepath#$src/}"
  size=$(stat -c %s "$filepath")
  echo "$relpath|$size"
done | sort > "$tmpdir/local.txt"

rclone ls "$dest" | while read -r line; do
  size=$(echo "$line" | awk '{print $1}')
  file=$(echo "$line" | cut -d' ' -f2-)
  echo "$file|$size"
done | sort > "$tmpdir/remote.txt"

# Show differences
echo ""
echo "❌ Files present on Android but missing or different on remote:"
comm -23 "$tmpdir/local.txt" "$tmpdir/remote.txt" | tee "$HOME/files_missing.txt"

echo ""
echo "📄 Report saved to: $HOME/storage/shared/files_missing.txt"

# Clean up
rm -rf "$tmpdir"
