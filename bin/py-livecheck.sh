#!/bin/sh

port installed | grep py311 | gsed -E 's/\s+(py)311([^ ]+) .*/\1\2/g' | xargs port livecheck
