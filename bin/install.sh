#!/bin/bash

# Install dotfiles and tools.

set -e

this_dir=$(dirname ${BASH_SOURCE:-$0})/..
this_dir=$(cd $(dirname $this_dir) && pwd)/$(basename $this_dir)
cd $this_dir

./bin/install_dotfiles.sh
./bin/install_tool.sh $*

