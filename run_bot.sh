#!/bin/bash
BASE_PATH=`pwd`
pushd src
ruby runner.rb "${BASE_PATH}" "$1"
popd
