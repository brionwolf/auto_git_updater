#!/bin/bash

# 0) Pull a branch, update local files accordingly, and push changes to same branch on remote
# 0.a) Global Arguments
which_branch=$1

# -------------------------------
# 1) git check out - check out the desired branch (usueally the gh-pages branch)
# 1.a) get the current branch
current_branch=$(git branch | grep \* | cut -d ' ' -f2)

# 1.b) Switch to branch passed in as an argument.
if [ $# -eq 0  ]
  then
    echo -e "No branch provided, using current branch '$current_branch'."
  else
    env -i git checkout $which_branch
fi

# -------------------------------
# 2) git pull origin or 'git up' to update local with any possible remote changes.
env -i git remote update -p
env -i git merge --ff-only @{u}

# 2.a) Why use `remote update`, and `git merge` over `git pull`: https://stackoverflow.com/questions/15316601/in-what-cases-could-git-pull-be-harmful/15316602#15316602

# -------------------------------
# 3. remove/add/update local files

# -------------------------------
# 4. add/commit local changes in new commit.

# -------------------------------
# 5. git push origin

# -------------------------------

