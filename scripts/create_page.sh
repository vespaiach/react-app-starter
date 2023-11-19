#!/bin/bash

project_root="$HOME/working/jc-com"
page_root="${project_root}/src/pages"
loader_root="${project_root}/src/loaders"
action_root="${project_root}/src/actions"

get_file_name() {
  local name=$(basename $1)
  local dir=$(dirname $1)
  name=$(tr '[:upper:]' '[:lower:]' <<< ${name:0:1})${name:1}
  echo "$dir/$name"
}

file_name=$(get_file_name $1)

page_path="${page_root}/$1.tsx"
loader_path="${loader_root}/$file_name.ts"
action_path="${action_root}/$file_name.ts"

mkdir -p $(dirname "$page_path")
mkdir -p $(dirname "$loader_path")
mkdir -p $(dirname "$action_path")

echo "/* Auto-generation by Bash script */

import { useLoaderData } from 'react-router-dom'

export function Component() {
  useLoaderData();

  return (
    <h1>$file_name</h1>
  );
}
" > "$page_path"

echo "/* Auto-generation by Bash script */

export default async function loader() {
  return null;
}
" > "$loader_path"

echo "/* Auto-generation by Bash script */

export default async function action() {
  return null;
}
" > "$action_path"

npx prettier --write "$page_path"
npx prettier --write "$loader_path"
npx prettier --write "$action_path"
