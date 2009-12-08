#!/bin/bash
BASE_PATH=`pwd`
pushd src
ruby lullizio.rb "${BASE_PATH}" "$1"
popd
