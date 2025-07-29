#!/bin/sh
set -e

echo "Running ci_post_xcodebuild.sh"
echo "Branch: $CI_BRANCH"

if [[ "$CI_BRANCH" == release/* ]]; then
  echo "Running tag_release.sh for branch: $CI_BRANCH"
  sh "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/ci_scripts/tag_release.sh"
else
  echo "Not a release branch. Skipping tag."
fi
