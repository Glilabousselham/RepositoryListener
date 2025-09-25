#!/bin/bash

# cd /path/to/your/repo

# Get latest commit hash from remote
REMOTE_HASH=$(git ls-remote origin refs/heads/master | awk '{print $1}')

# Get current local commit hash
LOCAL_HASH=$(git rev-parse HEAD)

if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
    echo "Repository is up to date"
else
    echo "Updates available on remote"
fi
