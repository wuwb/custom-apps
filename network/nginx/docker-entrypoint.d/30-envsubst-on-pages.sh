#!/bin/sh

set -e

ME=$(basename $0)

auto_envsubst() {

  local template_dir="${ERRORPAGE_ENVSUBST_TEMPLATE_DIR:-/pages}"
  local suffix="${ERRORPAGE_ENVSUBST_TEMPLATE_SUFFIX:-.html}"
  local output_dir="${ERRORPAGE_ENVSUBST_OUTPUT_DIR:-/usr/share/nginx/html}"

  local template defined_envs relative_path output_path subdir
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  [ -d "$template_dir" ] || return 0
  if [ ! -w "$output_dir" ]; then
    echo >&3 "$ME: ERROR: $template_dir exists, but $output_dir is not writable"
    return 0
  fi

  find "$template_dir" -follow -type f -name "*$suffix" -print | while read -r template; do
    relative_path="${template#$template_dir/}"
    output_path="$output_dir/${relative_path%$suffix}$suffix"
    subdir=$(dirname "$relative_path")
    # create a subdirectory where the template file exists
    mkdir -p "$output_dir/$subdir"
    echo >&3 "$ME: Running envsubst on $template to $output_path"
    envsubst "$defined_envs" < "$template" > "$output_path"

    sed -i "s/^[[:space:]\t\n]*//g" "$output_path"

    cat "${template_dir}/pages.csv" | grep ";" | while read line; do
        CODE=$(echo "$line" | cut -d";" -f1)
        TITLE=$(echo "$line" | cut -d";" -f2)
        DESC=$(echo "$line" | cut -d";" -f3)

        export DEFAULT_CODE=$CODE
        export DEFAULT_TITLE=$TITLE
        export DEFAULT_DESC=$DESC
        export output_path="$output_dir/$CODE$suffix"

        envsubst "$defined_envs" < "$template" > "$output_path"
    done

  done
}

auto_envsubst

exit 0
