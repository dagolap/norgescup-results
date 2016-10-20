#!/bin/bash

cd "$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
sudo npm install -g elm
npm install
elm package install --yes

