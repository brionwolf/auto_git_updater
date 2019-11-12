# auto_git_updater

### What it does:
1. Fetches the latest changes for a specified branch
2. Asks for a script that makes changes to the local project
3. Pushes those changes to the remote project on the current branch.

### Installation
1) `git clone` this project to your local environment.
2) copy/move the executable `.auto_push.sh` to the project you wish to use this script in.
3) Provide an executable that makes updates to the project.
4) See below for usage information.

### Usage:
`cmd [-b branch_name] [-e /path/to/executable.sh]`

### Available Flags:
`-b` Define a branch to pull and update. If unset, script will use the current Branch.  
`-e` Provide an executable that makes updates to the current project. If no executable is provided, the script will fail.  
`-h` Display help, and usage information.
