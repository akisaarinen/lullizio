#!/bin/bash
BASE_PATH=`pwd`
pushd src
if [ -f "twitter_env" ]; then
  source twitter_env
fi
./runner.rb "${BASE_PATH}" "$1"
popd
