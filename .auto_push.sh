#!/bin/bash

# Global Arguments
which_branch=$1

# Pull a branch, update local files accordingly, and push changes to same branch on remote

# git check out - check out the desired branch (usueally the gh-pages branch)

# get the current branch
current_branch=$(git branch | grep \* | cut -d ' ' -f2)

# Switch to branch passed in as an argument.
if [ $# -eq 0  ]
  then
    echo "No branch provided, using current branch: $current_branch"
  else
    env -i git checkout $which_branch
fi

# git pull origin or 'git up' to update local with any possible remote changes.
# remove/add/update local files
# add/commit local changes in new commit.
# git push origin
