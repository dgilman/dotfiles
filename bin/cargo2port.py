#!/usr/bin/env python3.9
import sys

import toml

with open(sys.argv[1]) as fd:
    lockfile = toml.load(fd)

longest_name_len = max(len(package['name']) for package in lockfile['package'])
longest_version_len = max(len(package['version']) for package in lockfile['package'])
total_space = longest_name_len + longest_version_len + 1

for package_idx, package in enumerate(lockfile['package'], start=1):
    if 'checksum' not in package:
        continue
    out = '    '
    out += package['name']
    out += ' ' * (total_space - len(package['name']) - len(package['version']))
    out += package['version']
    out += '  '
    out += package['checksum']
    if package_idx != len(lockfile['package']):
        out += ' \\'
    print(out)
