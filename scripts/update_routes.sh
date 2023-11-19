#!/bin/bash

# _root: directory
# _rel_root: relative directory (without project root)
# _path: full file path
# _rel_path: relative file path
# _name: file name without extension
# _ext: file extension

project_root="$HOME/working/jc-com"
page_root="${project_root}/src/pages"
loader_root="${project_root}/src/loaders"
action_root="${project_root}/src/actions"

route_path="${project_root}/src/routes.tsx"

# utilities
join() { local IFS="/"; echo "$*"; }
pascal_2_dash() { echo "$1" | sed 's/\([a-z]\)\([A-Z]\)/\1-\2/g' | tr '[:upper:]' '[:lower:]'; }
lowercase() {
  echo $(tr '[:upper:]' '[:lower:]' <<< ${1:0:1})${1:1}
}
get_file_name() {
  local name=$(basename $1)
  echo $(lowercase "${name%.*}")
}
get_loader_rel_path() {
  local rel=$(dirname "${1#$page_root}")
  local name=$(basename $1)
  name=$(lowercase "${name%.*}")
  if [ $rel = '/' ]; then
    echo "/$name.ts"
  else
    echo "$rel/$name.ts"
  fi
}
get_loader_path() {
  echo "$loader_root$(get_loader_rel_path $1)"
}
get_page_rel_path() {
  local rel=$(dirname "${1#$page_root}")
  local name=$(basename $1)
  if [ $rel = '/' ]; then
    echo "/$name"
  else
    echo "$rel/$name"
  fi
}
get_route_path() {
  local path=$(dirname "${1#$page_root}")
  local name=$(get_file_name $1)
  if [ $path = '/' ]; then
    echo "/$(pascal_2_dash $name)"
  else
    echo "$(echo $path | tr '[:upper:]' '[:lower:]')/$(pascal_2_dash $name)"
  fi
}

routes=''
loaders_import=''
raw_paths=$(find "${project_root}/src/pages" -type f -name '*.tsx')
read -r -d '' -a paths <<< "$raw_paths"
# Find all pages and pipe to while loop
for path in "${paths[@]}"; do
  loader_path=$(get_loader_path "$path")
  loader_rel_path=$(get_loader_rel_path "$path")
  loader_name="$(get_file_name "$path")Loader"
  loader_prop=''

  if [ -f "$loader_path" ]; then
    loader_prop=" loader={$loader_name} "
    loaders_import+="import $loader_name from '@loaders$loader_rel_path';"$'\n'
  fi

  routes+="    <Route path=\"$(get_route_path $path)\"${loader_prop}lazy={() => import(\"@pages$(get_page_rel_path $path)\")} />"$'\n'
done

echo "/* Auto-generation by Bash script */

import { Route, createRoutesFromElements } from 'react-router-dom'
import App from './App'
$loaders_import

const routes = createRoutesFromElements(
  <Route element={<App />}>
    $routes
  </Route>
);

export default routes;
" > "$route_path";

npx prettier --write "$route_path"

