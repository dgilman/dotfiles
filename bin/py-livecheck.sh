#!/bin/sh

port installed | grep py313 | gsed -E 's/\s+(py)313([^ ]+) .*/\1\2/g' | xargs port livecheck
