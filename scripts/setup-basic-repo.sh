#!/usr/bin/env bash

TARGET_DIR=git-101

CURRENT_DIR=$(basename "$PWD")
if [ "$CURRENT_DIR" == "$TARGET_DIR" ]; then
    echo "Aborting: you are currently inside a directory called ${TARGET_DIR} (please remove or run script in another place)"
    exit 1
fi

if [ -d "$TARGET_DIR" ]; then
    echo "Aborting: directory ${TARGET_DIR} already exists (please remove or run script in another place)"
    exit 2
fi

mkdir $TARGET_DIR

pushd $TARGET_DIR

git init

echo "foo" > file1.txt
git add file1.txt && git commit -m 'Add file1.txt'

echo "bar" >> file1.txt
git add file1.txt && git commit -m 'Write "bar" in file1.txt'

echo "baz" >> file1.txt
git commit -am 'Write "baz" in file1.txt'

popd
