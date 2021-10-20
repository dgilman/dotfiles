#!/bin/sh

port installed | grep py39 | gsed -E 's/\s+(py)39([^ ]+) .*/\1\2/g' | xargs port livecheck
