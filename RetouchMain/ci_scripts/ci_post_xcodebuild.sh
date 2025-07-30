#!/bin/sh
set -e

echo "Running ci_post_xcodebuild.sh"
echo "Branch: $CI_BRANCH"

if [[ "$CI_BRANCH" == release/* && "$CI_XCODEBUILD_ACTION" == "archive" ]]; then
    if [[ -n $CI_APP_STORE_SIGNED_APP_PATH ]]; # checks if there is an AppStore signed archive after running xcodebuild
    then
        echo "Running tag_release.sh for branch: $CI_BRANCH"
        sh "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/ci_scripts/tag_release.sh"
    fi
else
    echo "Skipping tag. Not a release branch or not archive step."
fi
