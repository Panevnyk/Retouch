#!/bin/sh

set -e

echo "Running ci_post_xcodebuild.sh: Auto-tagging"

#BUILD=${CI_BUILD_NUMBER}
VERSION=$(xcodebuild -showBuildSettings \
  -project "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/Retouch.xcodeproj" \
  -scheme "RetouchMain" \
  | awk -F " = " '/MARKETING_VERSION/ { print $2 }')
BUILD=$(xcodebuild -showBuildSettings \
  -project "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/Retouch.xcodeproj" \
  -scheme "RetouchMain" \
  | awk -F " = " '/CURRENT_PROJECT_VERSION/ { print $2 }')
TAG="release/$VERSION-$BUILD"

echo "Tag to create: $TAG"
echo "Build number: $BUILD"

git config --global user.email "ci-bot@example.com"
git config --global user.name "XcodeCloud Bot"
git remote set-url origin https://x-access-token:$GITHUB_PAT@github.com/Panevnyk/Retouch.git

cd "$CI_PRIMARY_REPOSITORY_PATH"
git tag -a "$TAG" -m "Release $TAG (Build $BUILD)" || echo "⚠️ Tag already exists"
git push origin "$TAG"
