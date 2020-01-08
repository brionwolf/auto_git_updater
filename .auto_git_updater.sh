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

# Colors:
# ----------------------------------
c_red=$'\e[1;31m'
c_grn=$'\e[1;32m'
c_blu=$'\e[1;34m'
c_mag=$'\e[1;35m'
c_cyn=$'\e[1;36m'
c_wht=$'\e[0m'

function USAGE() {
  echo "USAGE: cmd [-b branch_name] [-e /path/to/executable.sh]

DESCRIPTION: Purpose of this script is to automate regular updates to static Jekyll sites. The script 1) fetches the latest changes for the current branch, 2) asks for a script that makes a change, and 3) pushes those changes to the current branch.

AVAILABLE FLAGS:
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
      USAGE
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Fail if an executable isn't provided.
if [[ -z "$EXECUTABLE" ]]; then
  echo "$c_red
ILLEGAL: Provide an execurable with the [-e] flag. $c_wht
" 1>&2
  USAGE
  exit 1
elif [[ "$EXECUTABLE" == ".auto_git_updater.sh" ]]; then
  echo "$c_red
ILLEGAL: Providing this executable to itself creates an endless loop.
Use a different executable.$c_wht
" 1>&2
  USAGE
  exit 1

fi

echo "-------------------
DATETIME: $(date)
-------------------"

# ----------------------------------
# 1) Checkout the desired branch or create a new one
echo "
Checking the branch
-------------------"

CURRENT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)

if [[ -z "$BRANCH_NAME" ]];
  then
    echo "No branch provided, using current branch, $c_blu'$CURRENT_BRANCH'$c_wht"
  else
    if [[ `git branch | grep $BRANCH_NAME` ]]
      then
        echo "Branch $c_blu'$BRANCH_NAME'$c_wht already exists. Switching to that branch."
        env -i git checkout $BRANCH_NAME
      else
        echo "Branch $c_blu'$BRANCH_NAME'$c_wht does not exist, Do you want to create it? (Yn)"
        read user_response
        if [[ "$user_response" = "y" || "$user_response" = "Y" ]]
          then
            echo "creating branch with name: $c_blu'$BRANCH_NAME'$c_wht"
            env -i git branch $BRANCH_NAME
            env -i git checkout $BRANCH_NAME
          else
            echo "Branch with name $c_blu'$BRANCH_NAME'$c_wht does not exist and was not created."
            echo $c_red"Exiting script."$c_wht
            exit 1
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
echo "
Running provided executable
---------------------------$c_blu"

source $EXECUTABLE
echo "$c_wht"

# ----------------------------------
# 4) Commit changes with a message including a datetime Stamp
echo "
Checking current state of git
-----------------------------"

env -i git status

echo "
Commit any changes
-----------------------------"

if git diff-index --quiet HEAD --;
  then
    echo "No changes were made"
  else
    env -i git add -A .
    git commit -m "Project updated with auto_git_updater — $(date)"
fi


echo "
Checking current state of git
-----------------------------"

env -i git status

# ----------------------------------
# 5) Push local changes to the remote instance of the curren branch
echo "
Attempting to push changes
--------------------------"

git push origin $(git branch | grep \* | cut -d ' ' -f2)

# ----------------------------------
