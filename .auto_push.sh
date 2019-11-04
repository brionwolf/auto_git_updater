# #!/bin/bash

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

# -------------------------------
# 2) git pull origin or 'git up' to update local with any possible remote changes.
# 2.note) Why use `remote update`, and `git merge` over `git pull`: https://stackoverflow.com/questions/15316601/in-what-cases-could-git-pull-be-harmful/15316602#15316602
env -i git remote update -p
env -i git merge --ff-only @{u}

# -------------------------------
# 3. remove/add/update local files
# 3.a) Check if file exists
# 3.b) delete it if it exists
file_to_create_or_edit=current_date.md
if test -f "$file_to_create_or_edit";
  then
    echo "'$file_to_create_or_edit' exists."
    rm $file_to_create_or_edit
  else
    echo "'$file_to_create_or_edit' does not exist and will be created as part of this script"
fi

# 3.c) Create a file with the same name, and Update it with the current datetime from bash
new_content="The current time is: $(date -u)";

echo $new_content >> $file_to_create_or_edit
echo "contents of '$file_to_create_or_edit' have been replaced with '$new_content'"

# -------------------------------
# 4. add/commit local changes in new commit.
# 4.a) Check current state
echo "Current git status"
env -i git status

# 4.b) Add modified file
env -i git add $file_to_create_or_edit

# 4.c) Commit changes to file
git commit -m "File updated with current date - $(date)"

# -------------------------------
# 5. git push origin
git push origin $(git branch | grep \* | cut -d ' ' -f2)

# -------------------------------
