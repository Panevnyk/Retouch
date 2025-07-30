#!/bin/sh

set -e

echo "Running ci_post_xcodebuild.sh: Auto-tagging"

echo "111: ${CI_PRIMARY_REPOSITORY_PATH}/RetouchMain.xcodeproj/project.pbxproj"
echo "222: ${CI_PRIMARY_REPOSITORY_PATH}/RetouchMain/RetouchMain.xcodeproj/project.pbxproj"

ls -la "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain.xcodeproj"
ls -la "$CI_PRIMARY_REPOSITORY_PATH/RetouchMain/RetouchMain.xcodeproj"

BUILD=${CI_BUILD_NUMBER}
VERSION=$(cat ${CI_PRIMARY_REPOSITORY_PATH}/RetouchMain/RetouchMain.xcodeproj/project.pbxproj | grep -m1 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ')
TAG="release/$VERSION-$BUILD"

echo "Tag to create: $TAG"
echo "Build number: $BUILD"

git config --global user.email "ci-bot@example.com"
git config --global user.name "XcodeCloud Bot"
git remote set-url origin https://x-access-token:$GITHUB_PAT@github.com/Panevnyk/Retouch.git

cd "$CI_PRIMARY_REPOSITORY_PATH"
git tag -a "$TAG" -m "Release $TAG (Build $BUILD)" || echo "⚠️ Tag already exists"
git push origin "$TAG"
