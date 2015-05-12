# Trello Snapshot

A simple bash script to fetch a Trello board as JSON and store it automatically with Git as snapshots.

## Requirements
* bash
* wget
* git

## Setup

### Install dependencies
Hey, you never know...

Using **su**:

```
# apt-get install wget git-core
```

Using **sudo**

```
sudo apt-get install wget git-core
```

### Git user name and e-mail address
You can skip this step if you have already hacked on and contributed to other projects that use git. If not, welcome :)

```shell
git config --global user.name "Goas Sasde"
```
and

```shell
git config --global user.email "name@domain.com"
```

## Configuration
Inside `trello-snapshot.sh` there are four settings that need to be set, with only two really being required.

### Required
Set the Git repository location without a trailing slash
```shell
GIT_REPO='/home/username/trello-backup'
```

Trello URL to download Trello Board JSON. If you are not sure where to find this [read this](http://help.trello.com/article/747-exporting-data-from-trello-1).
```shell
TRELLO_URL='https://trello.com/b/unique-id.json'
```

### Optional
The default commit message to use
```shell
GIT_COMMIT_MESSAGE='Updated Trello Board' # Default
```

An example would be:
```
[master 8b1ffb7] Updated Trello Board
 1 file changed, 1 insertion(+), 1 deletion(-)
```


Local file name for storing Trello Board JSON file and to use in git
```shell
FILE_NAME='trello-board.json' # Default
```

That's it. Time to backup your Trello board.

## Run manually
```shell
./trello-snapshot.sh
```

## Run at a specified time as a cron job
You can optionally run this script at a defined time, some examples are
```
@daily  /path/to/trello-snapshot.sh
@hourly /path/to/trello-snapshot.sh 2>&1 /dev/null # No output

# Every day at 4:30 am
30 4 * * * /path/to/trello-snapshot.sh

# Monthly at 4:30 am
30 4 1 * * /path/to/trello-snapshot.sh
```

## Bugs and feature requests
Please file any bugs and feature requests [here](https://github.com/octoquad/trello-snapshot/issues). Pull requests are always welcome.

-------
Made for the [South African Ubuntu team](https://ubuntu-za.org/) (and you of course).
