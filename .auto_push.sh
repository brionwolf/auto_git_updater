# #!/bin/bash
# Auto Push

# This Script will do the following:
# ----------------------------------
# 1) Checkout the desired branch or create a new one
# 2) Make sure the branch is up to date with "git pull"
# 3) Run an executable that makes local changes
# 4) Commit changes with a message including a datetime Stamp
# 5) Push local changes to the remote instance of the current branch

# Flags:
# ----------------------------------
# -b    (optional) Define a branch to pull and update. If unset, script will use the current Branch.
# -e    (required) Provide an executable that makes updates to the current project. If no executable is provided, the script will fail.

while getopts ":b:e:" opt; do
  case ${opt} in
    b )
      BRANCH_NAME=$OPTARG
      ;;
    e )
      EXECUTABLE=$OPTARG
      ;;
  esac
done
shift $((OPTIND -1))

# Fail if an executable isn't provided.
if [[ -z "$EXECUTABLE" ]]; then
  echo "FAILED. Exit code 1. Please Provide an execurable with the [-e] flag." 1>&2
  exit 1
fi

# ----------------------------------
# 1) Checkout the desired branch or create a new one
CURRENT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)

if [[ -z "$BRANCH_NAME" ]];
  then
    echo "No branch provided, using current branch: $CURRENT_BRANCH"
  else
    if [[ `git branch | grep $BRANCH_NAME` ]]
      then
        echo "Branch named $BRANCH_NAME already exists"
        env -i git checkout $BRANCH_NAME
      else
        echo "Branch named $BRANCH_NAME does not exist, Do you want to create it? (Yn)"
        read user_response
        if [[ "$user_response" = "y" || "$user_response" = "Y" ]]
          then
            echo "creating branch with name: $BRANCH_NAME"
            env -i git branch $BRANCH_NAME
            env -i git checkout $BRANCH_NAME
          else
            echo "Branch with name $BRANCH_NAME does not exist and was not created."
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
