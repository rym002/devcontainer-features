#!/bin/bash

set -e

source dev-container-features-test-lib


check "execute command" smartthings --help
check "mount" test -f /mnt/@smartthings/test.txt
check "link" test -f ~/.config/@smartthings/test.txt

reportResults