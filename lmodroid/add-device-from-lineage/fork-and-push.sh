#!/bin/bash

usage()
{
    echo "Usage: $0 <repo_src> <branch_src> <repo_dist> <branch_dist>"
}

if [ "$4" == "" ]; then
    echo "ERROR: Enter all needed parameters"
    usage
    exit 1
fi

if [[ ! -f "token" ]]; then
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "ERROR: Set the GITHUB_TOKEN environment variable"
    exit 1
fi
echo "$GITHUB_TOKEN" > token
fi
# Authenticate using GH
gh auth login --with-token < token

export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
LOCALDIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

repo_src=$1
branch_src=$2
repo_dist=$3
branch_dist=$4

#ssh -p 29418 -o StrictHostKeyChecking=no ${GERRIT_USER}@gerrit.libremobileos.com gerrit create-project --parent LMODroid-Device-Projects ${repo_dist}

if [[ ! -d working ]]; then
    mkdir -p working
fi
cd working

repo_dist_dir=`echo $repo_dist | cut -d "/" -f 2`
if [[ -d ${repo_dist_dir} ]]; then
    rm -rf ${repo_dist_dir}
fi

git clone https://github.com/${repo_dist}.git 
#scp -p -P 29418 ${GERRIT_USER}@gerrit.libremobileos.com:hooks/commit-msg "${repo_dist_dir}/.git/hooks/"
if [[ ! -d ${repo_dist_dir} ]]; then
    echo "ERROR: Repo failed to clone"
    exit 1
fi
cd ${repo_dist_dir}

git remote add lineage https://github.com/${repo_src}.git
git fetch lineage
git checkout lineage/${branch_src}
git switch -c ${branch_dist}

# Adapt
python "${LOCALDIR}/../lineage-device-tree/adapt-to-lmodroid.py" . ${branch_src}

git add -A
git commit -m "Adapt to LMODroid by device-add script"

git push --set-upstream -o skip-validation origin ${branch_dist}
