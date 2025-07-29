#!/bin/sh

set -e

echo "Running ci_post_xcodebuild.sh: Auto-tagging"

ls -la "$CI_WORKSPACE/RetouchMain"

echo "$CI_WORKSPACE/RetouchMain"

VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$CI_WORKSPACE/RetouchMain/RetouchMain/Info.plist")
BUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$CI_WORKSPACE/RetouchMain/RetouchMain/Info.plist")

TAG="v$VERSION"

echo "Tag to create: $TAG"
echo "Build number: $BUILD"

git config --global user.email "ci-bot@example.com"
git config --global user.name "XcodeCloud Bot"
git remote set-url origin https://x-access-token:$GITHUB_PAT@github.com/Panevnyk/Retouch.git

cd "$CI_PRIMARY_REPOSITORY_PATH"
git tag -a "$TAG" -m "Release $TAG (Build $BUILD)" || echo "⚠️ Tag already exists"
git push origin "$TAG"
