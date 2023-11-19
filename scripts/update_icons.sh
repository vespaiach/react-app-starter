#!/bin/bash

project_root="$HOME/working/jc-com"
icon_file="${project_root}/src/components/Icon.tsx"

function snake_to_pascal() {
  local words
  local result
  read -r -a words <<< $(echo "$1" | tr '_' ' ')
  for word in "${words[@]}"; do
    result+="$(tr '[:lower:]' '[:upper:]' <<< ${word:0:1})${word:1}"
  done
  echo $result
}


echo "/* Auto-generation by Bash script */
import { CSSProperties, useMemo } from 'react';
import styled from '@emotion/styled/macro';
import { blue140 } from '@/commons/colors';
" > "$icon_file"

read -r -a svg_files <<< $(find "${project_root}/src/assets/svgs" -type f -name "*.svg")
mapping="\nconst mapping = {"
for svg in ${svg_files[@]}; do
  file_name=$(basename $svg)
  component_name=$(snake_to_pascal "${file_name//.svg/}")
  mapping+="'$(tr '_' '-' <<< ${file_name//.svg/})': ${component_name},"
  echo "import $component_name from '@assets/svgs/${file_name}?react';" | tee -a "$icon_file"
done;
mapping+='}'
echo -e "$mapping" | tee -a "$icon_file"

echo -e "interface IconProps{
  type: keyof typeof mapping
  color?: string
  display?: CSSProperties['display']
}

export default function Icon ({ type, display = 'inline-block', color = blue140, ...rest }: IconProps): JSX.Element {
  const Svg = useMemo(
    () => styled(mapping[type])\`
      display: \${display};
      color: \${color};
    \`,
    [type, color, display]
  )
  return <Svg {...rest} />
}" | tee -a "$icon_file"

npx prettier --write "$icon_file"
