#!/bin/sh
set -e

echo "Running ci_post_xcodebuild.sh"
echo "Workflow: $CI_WORKFLOW_NAME"

if [ "$CI_WORKFLOW_NAME" = "Release: TestFlight" ]; then
  echo "Running tag_release.sh for workflow '$CI_WORKFLOW_NAME'"
  sh "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/ci_scripts/tag_release.sh"
else
  echo "Not a release workflow. Skipping tag."
fi
