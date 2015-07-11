#!/usr/bin/env bash

#
# Trello Snapshot
#
# Author: Bruce Pieterse <dev@otq.za.net>
# Version: 0.1
#

#
## Settings
#

## Git Repository Location (no trailing slash)
GIT_REPO=''

## Default commit message to use
GIT_COMMIT_MESSAGE=''

## Trello URL to download Trello Board JSON
TRELLO_URL=''

## Local file name for storing Trello Board JSON and to use in a git commit
FILE_NAME='.json'

#
## Core
#

config_check() {
    if [ ${#GIT_REPO} -eq 0 ]; then
        echo "[!] You need to set a location for the git directory."

        exit 1
    fi

    if [ ${#TRELLO_URL} -eq 0 ]; then
        echo "[!] You need to set the URL to use for downloading the Trello board."

        exit 1
    fi

    if [ ${#GIT_COMMIT_MESSAGE} -eq 0 ]; then
        GIT_COMMIT_MESSAGE='Updated Trello Board'

        echo "[!] No default commit message set. Will use \"$GIT_COMMIT_MESSAGE\" as the default until set."
    fi

    if [ ${#FILE_NAME} -eq 0 ]; then
        FILE_NAME='trello-board.json'

        echo "[!] Name to store Trello board is missing. Will use \"$FILE_NAME\" as the default until set."
    fi

    FULL_PATH="$GIT_REPO/$FILE_NAME"
}

git_commit_file() {
    if [ -e $FULL_PATH ]; then
        cd $GIT_REPO

        git add $FILE_NAME
        git commit -m "$GIT_COMMIT_MESSAGE"
    fi
}

git_config_email_check() {
    len=`git config user.email`
    len="${#len}"

    if [ $len -lt 5 ]; then
        echo -e "[!] Please set a valid git e-mail address with" \
        "\033[1mgit config --global user.email\033[0m name@example.com"

        exit 1
    fi
}

git_config_name_check() {
    len=`git config user.name`
    len="${#len}"

    if [ $len -lt 3 ]; then
        echo -e "[!] Please set a valid git name with \033[1mgit config --global user.name\033[0m Name Here"

        exit 1
    fi
}

git_config_check() {
    git_config_name_check
    git_config_email_check
}

git_exists() {
    if git --version &> /dev/null; then
        GIT_CMD=`which git`
    else
        echo -e '[!] Git is missing! Please install the package \033[1mgit-core\033[0m and re-run this script.'

        exit 1
    fi
}

git_repo_dir_exists() {
    if [ ! -d "$GIT_REPO" ]; then
        echo "[*] Git directory does not exist. Creating..."

        mkdir -p $GIT_REPO

        if [ $? -eq 0 ]; then
            echo "[-] Git directory created successfully. Moving on..."
        else
            echo "[!] Unable to create git directory. Please create manually and re-run this script"

            exit 1
        fi
    fi
}

git_repo_initialize() {
    if [ ! -d "$GIT_REPO/.git" ]; then
        echo "[*] Git repository has not been initialized yet. Initializing..."

        cd $GIT_REPO

        $GIT_CMD init
    fi
}

wget_exists() {
    if wget --version &> /dev/null; then
        WGET_CMD=`which wget`
    else
        echo -e '[!] Please install the package \033[1mwget\033[0m and re-run this script.'

        exit 1
    fi
}

wget_fetch() {
    echo '[*] Fetching Trello Board...'

    $WGET_CMD --quiet $TRELLO_URL -O "$FULL_PATH"

    if [ $? -eq 0 ]; then
        echo "[-] Trello board downloaded successfully."
    else
        echo "[!] Failed to retrieve Trello Board at $TRELLO_URL."

        exit 1
    fi
}

config_check
wget_exists
git_exists
git_config_check
git_repo_dir_exists
git_repo_initialize
wget_fetch
git_commit_file

exit 0
