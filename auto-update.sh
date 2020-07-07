#!/bin/sh

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

while true; do
    if [ $LOCAL = $REMOTE ]; then
        echo "Up-to-date"
    elif [ $LOCAL = $BASE ]; then
        echo "Need to pull"
    elif [ $REMOTE = $BASE ]; then
        echo "Need to push"
    else
        echo "Diverged"
    fi

    if [[ -n $(git status -s) ]]; then
        echo "Changes found. Pushing changes..."
        git add -A && git commit -m 'update' && git push
    else
        echo "No changes found. Skip pushing."
    fi

    sleep 5
done
