#!/bin/bash


# Default values (empty, required)
REPO_DIR=""
DEPLOY_SCRIPT=""
REMOTE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
SLEEP_INTERVAL=120  # seconds

echo "Current branch: $CURRENT_BRANCH"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --local-repo=*)
            REPO_DIR="${arg#*=}"
            shift
            ;;
        --deploy-script=*)
            DEPLOY_SCRIPT="${arg#*=}"
            shift
            ;;
        *)
            echo "Unknown argument: $arg"
            ;;
    esac
done

# Validate required arguments
if [ -z "$REPO_DIR" ] || [ -z "$DEPLOY_SCRIPT" ] || [ -z "$REMOTE_BRANCH" ]; then
    echo "Error: Missing required arguments."
    echo "Usage: $0 --local-repo=/path/to/repo --deploy-script=/path/to/deploy/script --branch=branch-name-to-check"
    exit 1
fi




# run the check script

# Go to repo
cd "$REPO_DIR" || { echo "Error: Cannot cd to $REPO_DIR"; exit 1; }

# Infinite loop
while true; do
    # Get latest commit hash from remote
    REMOTE_HASH=$(git ls-remote origin "refs/heads/$REMOTE_BRANCH" | awk '{print $1}')
    LOCAL_HASH=$(git rev-parse HEAD)

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "$(date): Updates detected on branch '$REMOTE_BRANCH', running deploy..."
        
        bash "$DEPLOY_SCRIPT"
    else
        echo "$(date): Repository '$REMOTE_BRANCH' is up to date."
    fi

    sleep "$SLEEP_INTERVAL"
done
