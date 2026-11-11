#!/usr/bin/env bash
set -euo pipefail

bin_dir="$HOME/.local/bin"
mkdir -p "$bin_dir"

cat > "$bin_dir/java-version" <<'EOF'
#!/usr/bin/env bash
set -e
if ! command -v java >/dev/null 2>&1; then
  echo "java is not installed or is not on PATH." >&2
  exit 127
fi
exec java -version
EOF

cat > "$bin_dir/gradle-version" <<'EOF'
#!/usr/bin/env bash
set -e
if ! command -v gradle >/dev/null 2>&1; then
  echo "gradle is not installed or is not on PATH." >&2
  exit 127
fi
exec gradle --version
EOF
chmod +x "$bin_dir/java-version" "$bin_dir/gradle-version"

path_line='export PATH="$HOME/.local/bin:$PATH"'
for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$rc_file" ] && ! grep -Fqx "$path_line" "$rc_file"; then
    printf '\n# Add Codespaces version commands to PATH\n%s\n' "$path_line" >> "$rc_file"
  fi
done
