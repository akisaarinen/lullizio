#!/bin/bash
BASE_PATH=`pwd`
pushd lib
if [ -f "twitter_env" ]; then
  source twitter_env
fi
./lullizio.rb "${BASE_PATH}" "$1"
popd
