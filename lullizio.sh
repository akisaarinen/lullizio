#!/bin/bash
BASE_PATH=`pwd`
pushd src
ruby lullizio_runner.rb "${BASE_PATH}" "$1"
popd
