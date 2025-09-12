#!/bin/bash

# Read Claude Code JSON input
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Directory name function (equivalent to %1/%)
directory_name() {
  basename "$cwd"
}

# Git functions (adapted from zsh prompt)
git_branch() {
  git symbolic-ref HEAD 2>/dev/null | awk -F/ '{print $NF}'
}

git_dirty() {
  if ! git status -s &> /dev/null; then
    echo ""
  else
    if [[ $(git status --porcelain 2>/dev/null) == "" ]]; then
      # Clean - green
      printf "on \033[1;32m%s\033[0m" "$(git_branch)"
    else
      # Dirty - red  
      printf "on \033[1;31m%s\033[0m" "$(git_branch)"
    fi
  fi
}

need_push() {
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
      number=$(git cherry -v origin/"$branch" 2>/dev/null | wc -l)
      if [[ $number -gt 0 ]]; then
        printf " with \033[1;35m%s unpushed\033[0m" "$number"
      fi
    fi
  fi
}

# Change to the working directory for git commands
cd "$cwd" 2>/dev/null || true

# Build the prompt (without the leading newline and trailing prompt symbol)
printf "in \033[1;36m%s\033[0m %s%s" "$(directory_name)" "$(git_dirty)" "$(need_push)"