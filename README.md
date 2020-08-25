# auto_git_updater

## Why?
A few static sites managed by [OSC](https://osc.umd.edu) include events feeds that need to be updated on a regular basis. At the time this script was created, [github pages had no way to rebuild and update a site](https://stackoverflow.com/a/24099328) without commiting and pushing a change, or with parameters like replacing a cached file first. This script was a solution.

## What it does
1. Fetches the latest changes for a specified branch.
2. Asks for a script that makes changes to the local project.
3. Pushes those changes to the remote project on the current branch.

## Installation
1. `git clone` or download a `zip` of this project to your local environment.
2. copy/move the executable `.auto_push.sh` to the project you wish to use this script in.
3. Provide an executable that makes updates to the project.
4. Run the script _(See below for usage information)_.

## Usage
`cmd [-b branch_name] [-e /path/to/executable.sh]`  
_Paired with a cron job, this script can be run on a regular basis._

#### _CronTab/Cron job resources_
* Manual (_"man page"_) for the crontab utility used for making cron jobs: [crontab.org](http://crontab.org/).
* Wikipedia page on cron: [wikipedia.org — Cron](https://en.wikipedia.org/wiki/Cron)
* "How To" writeup by opensource.com: [opensource.com — How to use cron in Linux](https://opensource.com/article/17/11/how-use-cron-linux)
* Cron job examples from reddit: [reddit.com — What Cron Jobs Do You Have Running?](https://www.reddit.com/r/linux/comments/5h861f/what_cron_jobs_do_you_have_running/)

## Available Flags:
`-b` — Define a branch to pull and update. If unset, script will use the current Branch.  
`-e` — Provide an executable that makes updates to the current project. If no executable is provided, the script will fail.  
`-h` — Display help, and usage information.
