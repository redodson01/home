#!/usr/bin/env bash

input=$(cat)

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

if [ -z "$used" ]; then
  printf "Context: no messages yet"
  exit 0
fi

used_int=$(printf "%.0f" "$used")

bar_width=20
filled=$(( used_int * bar_width / 100 ))
empty=$(( bar_width - filled ))

bar=""
for i in $(seq 1 $filled); do bar="${bar}█"; done
for i in $(seq 1 $empty); do bar="${bar}░"; done

printf "%s %d%%" "$bar" "$used_int"
