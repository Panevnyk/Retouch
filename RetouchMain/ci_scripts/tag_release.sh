#!/bin/sh

set -e

echo "Running ci_post_xcodebuild.sh: Auto-tagging"

#VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/RetouchMain/Info.plist")
#BUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/RetouchMain/Info.plist")

VERSION=$(xcodebuild -showBuildSettings -scheme RetouchMain | awk -F " = " '/MARKETING_VERSION/ {print $2}')
BUILD=$(xcodebuild -showBuildSettings -scheme RetouchMain | awk -F " = " '/CURRENT_PROJECT_VERSION/ {print $2}')
TAG="v$VERSION"

echo "Tag to create: $TAG"
echo "Build number: $BUILD"

git config --global user.email "ci-bot@example.com"
git config --global user.name "XcodeCloud Bot"
git remote set-url origin https://x-access-token:$GITHUB_PAT@github.com/Panevnyk/Retouch.git

cd "$CI_PRIMARY_REPOSITORY_PATH"
git tag -a "$TAG" -m "Release $TAG (Build $BUILD)" || echo "⚠️ Tag already exists"
git push origin "$TAG"
