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

function USERAGE() {
  echo "USERAGE: cmd [-b branch_name] [-e .executable_to_run.sh]

DESCRIPTION: Purpose of this script is to automate regular updates to static Jekyll sites. The script 1) fetches the latest changes for the current branch, 2) asks for a script that makes a change, and 3) pushes those changes to the current branch.

Available Flags:
-b    Define a branch to pull and update. If unset, script will use the current Branch.
-e    Provide an executable that makes updates to the current project. If no executable is provided, the script will fail.
-h    Display help, and usage information." 1>&2
}

while getopts ":b:e:h" opt; do
  case ${opt} in
    b )
      BRANCH_NAME=$OPTARG
      ;;
    e )
      EXECUTABLE=$OPTARG
      ;;
    h )
      USERAGE
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Fail if an executable isn't provided.
if [[ -z "$EXECUTABLE" ]]; then
  echo "ILLEGAL. Provide an execurable with the [-e] flag.
" 1>&2
  USERAGE
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
