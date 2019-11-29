#!/bin/sh

set -e

git remote set-url origin "https://user:$GITHUB_TOKEN@github.com/$GH_REPO.git"
npm set //registry.npmjs.org/:_authToken "$NPM_TOKEN"

git fetch origin "$GH_BRANCH":"$GH_BRANCH"
git checkout "$GH_BRANCH"

yarn global add lerna-changelog
lerna-changelog

if [ "$GH_REF" = "refs/heads/master" ]; then
	yarn lerna publish --create-release github --yes
else
	yarn lerna publish --canary --conventional-prerelease --force-publish --preid beta --pre-dist-tag beta --yes
fi
