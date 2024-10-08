#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# get current script dir
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# clone the chainlit repo if it is not already cloned
if [ ! -d "$SCRIPT_DIR/chainlit" ]; then
    git clone https://github.com/Chainlit/chainlit.git $SCRIPT_DIR/chainlit
fi

#### START - Building the chainlit project ####
cd $SCRIPT_DIR/chainlit

git reset --hard 6189fc1f6cb4f2066d08f11ffba33527b12dd5a5
git apply $SCRIPT_DIR/patch.diff

# install poetry
pip3 install poetry --break-system-packages

# install node dependencies
pnpm install

# build the project
pnpm build

# install chainlit
cd src
poetry install
cd ..
cd ..

#### END - Building the chainlit project ####

# install app dependencies
pip3 install -r requirements.txt --break-system-packages

echo "assistant app setup complete"
