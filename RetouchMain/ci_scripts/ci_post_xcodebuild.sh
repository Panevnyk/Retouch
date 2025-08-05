#!/bin/sh
set -e

echo "Running ci_post_xcodebuild.sh"
echo "Branch: $CI_BRANCH"

if [[ -n $CI_APP_STORE_SIGNED_APP_PATH ]]; then # checks if there is an AppStore signed archive after running xcodebuild
    if [[ "$CI_BRANCH" == release/* ]]; then
        echo "Running tag_release.sh for branch: $CI_BRANCH"
        sh "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/ci_scripts/tag_release.sh"
    else
        echo "Skipping tag. Not a release branch."
    fi
else
    echo "Skipping tag. Not archive step."
fi
