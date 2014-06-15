#!/usr/bin/env python

symlinks = {"bash_profile": "~/.bash_profile",
   "bashrc": "~/.bashrc",
   "gitconfig": "~/.gitconfig",
   "sshconfig": "~/.ssh/config",
   "vimrc": "~/.vimrc",
   "wgetrc": "~/.wgetrc",
   "bin/pre-commit-dotfiles": "~/dotfiles/.git/hooks/pre-commit",
   "ledgerrc": "~/.ledgerrc",
   "dput.cf": "~/.dput.cf",
   "muttrc": "~/.muttrc"}

import subprocess
import os
import sys

symlinks_tmp = {}
for key, value in symlinks.items():
   symlinks_tmp[os.path.abspath(key)] = os.path.expanduser(value)

symlinks = symlinks_tmp

already_exists = []
for path in symlinks.values():
   if os.path.exists(path):
      already_exists.append(path)

if len(already_exists) != 0 and '--force' not in sys.argv:
   print "Some of these paths exist!  Fix the problem (or call with --force)!"
   print already_exists
   sys.exit(-1)

for key, value in symlinks.items():
   print "Symlinking %s to %s..." % (key, value)
   try:
      os.symlink(key, value)
   except OSError:
      if '--force' not in sys.argv:
         raise

subprocess.call(["git", "submodule", "init"])
subprocess.call(["git", "submodule", "update"])

print "All done!"
print "eregex.vim lives in ./vim and is a git submodule.  If you've got vim 7.3 or better you probably want to install it with a make install."
