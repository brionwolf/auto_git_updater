# #!/bin/bash
# Auto Push

# This Script will do the following:
# ----------------------------------
# 1) Checkout the desired branch or create a new one
# 2) Make sure the branch is up to date with "git pull"
# 3) Run an executable that makes local changes
# 4) Commit changes with a message including a datetime Stamp
# 5) Push local changes to the remote instance of the curren branch

# Options:
# ----------------------------------
# $which_branch - Define a specific git branch to use. If the branch specified does not exist, the script will ask if a new branch should be created.

# Options:
# ----------------------------------
which_branch=$1

# ----------------------------------
# 1) Checkout the desired branch or create a new one
current_branch=$(git branch | grep \* | cut -d ' ' -f2)

if [[ $# -eq 0 ]]
  then
    echo "No branch provided, using current branch: $current_branch"
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
        fi
    fi
fi

# ----------------------------------
# 2) Make sure the branch is up to date with "git pull"
  # Note: Why use `remote update`, and `git merge` over `git pull`: https://stackoverflow.com/questions/15316601/in-what-cases-could-git-pull-be-harmful/15316602#15316602
env -i git remote update -p
env -i git merge --ff-only @{u}

# ----------------------------------
# 3) Run an executable that makes local changes

# ----------------------------------
# 4) Commit changes with a message including a datetime Stamp
echo "Current git status"
env -i git status

if git diff-index --quiet HEAD --;
  then
    echo "No changes were made"
  else
    env -i git add $file_to_create_or_edit
    git commit -m "File updated with current date - $(date)"
fi

# ----------------------------------
# 5) Push local changes to the remote instance of the curren branch
git push origin $(git branch | grep \* | cut -d ' ' -f2)

# ----------------------------------
