#!/bin/bash


# cd /path/to/your/repo

# Fetch latest changes
git fetch origin master

# Check if behind remote
BEHIND=$(git rev-list HEAD..origin/master --count)

if [ "$BEHIND" -gt 0 ]; then
    echo "Updates available: $BEHIND commits behind"
else
    echo "Repository is up to date"
fi