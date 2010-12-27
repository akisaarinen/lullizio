#!/bin/bash
BASE_PATH=`pwd`
pushd src
./runner.rb "${BASE_PATH}" "$1"
popd
