#!/bin/bash

# This is a script for updating the material in the ext directory.
# It is a bit delicate, and for use in automation.

if [ ! -e ../grist/ext ]; then
  echo "Please call script in a repo that is side-by-side with grist repo"
  exit 1
fi

workdir=tmp_checkout

set -ex

# Make a clean copy of ext directory by brute force.
rm -rf $workdir
git clone ../grist $workdir
# It is nice to keep core and ext code in sync. Let's look at the latest
# commit in core, then try to find where it lives in monorepo. This will
# fail if the latest commit in core didn't in fact come from monorepo.
pushd core
core_commit=$(git rev-parse HEAD)
popd
pushd $workdir
git checkout $core_commit
ext_commit=$(git log --pretty=format:"%H" --reverse --ancestry-path HEAD..origin/master | head -n1)
git log --oneline --reverse --ancestry-path HEAD..origin/master
git log --oneline --reverse --ancestry-path HEAD..origin/master | head -n1 | grep "Split .core/. into commit .$core_commit." || {
  echo "Could not find ext commit to go with core"
  exit 1
}
git checkout $ext_commit
popd
rm -rf ext
cp -r $workdir/ext ext
git add --all ext
rm -rf $workdir
echo "core commit is $core_commit"
echo "ext commit is $ext_commit"
