#!/bin/bash

# 0) Pull a branch, update local files accordingly, and push changes to same branch on remote
# 0.a) Global Arguments
which_branch=$1
command_or_string=$2

# -------------------------------
# 1) git check out - check out the desired branch (usueally the gh-pages branch)
# 1.a) get the current branch
current_branch=$(git branch | grep \* | cut -d ' ' -f2)

# 1.b) Switch to branch passed in as an argument.

if [[ $# -eq 0 ]]
  then
    echo "No branch provided, using current branch: $current_branch"
    exit 2
  else
    if [[ `git branch | grep $which_branch` ]]
      then
        echo "Branch named $which_branch already exists"
        env -i git checkout $which_branch
      else
        echo "Branch named $which_branch does not exist, Do you want to create it? (Yn)"
        read user_response
        if [[ "$user_response" = "y" || "$user_response" = "Y" ]]
          then
            echo "creating branch with name: $which_branch"
            env -i git branch $which_branch
            env -i git checkout $which_branch
          else
            echo "Branch with name $which_branch does not exist and was not created."
            exit 2
        fi
    fi
fi

# -------------------------------
# 2) git pull origin or 'git up' to update local with any possible remote changes.
env -i git remote update -p
env -i git merge --ff-only @{u}

# 2.a) Why use `remote update`, and `git merge` over `git pull`: https://stackoverflow.com/questions/15316601/in-what-cases-could-git-pull-be-harmful/15316602#15316602

# -------------------------------
# 3. remove/add/update local files
date >> README.md

# -------------------------------
# 4. add/commit local changes in new commit.

# -------------------------------
# 5. git push origin

# -------------------------------

