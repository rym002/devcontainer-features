#!/bin/bash

set -e

source dev-container-features-test-lib

check "execute command" smartthings --help
check "@smartthings mounted" test -f /mnt/@smartthings/test.txt
check "@smartthings linked to $HOME" test -f ~/.config/@smartthings/test.txt
check "autocomplete" grep -q "smartthings autocomplete:script bash" ~/.bashrc
reportResults