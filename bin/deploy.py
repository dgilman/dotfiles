#!/usr/bin/env python3

symlinks = {
   "bash_profile": "~/.bash_profile",
   "bashrc": "~/.bashrc",
   "gitconfig": "~/.gitconfig",
   "sshconfig": "~/.ssh/config",
   "vimrc": "~/.vimrc",
   "wgetrc": "~/.wgetrc",
   "bin/pre-commit-dotfiles": "~/dotfiles/.git/hooks/pre-commit",
   "ledgerrc": "~/.ledgerrc",
   "pgcli": "~/.pgcli",
   "psqlrc": "~/.psqlrc",
}
dirs = {"sshfolder": "~/.ssh"}
utils = ["ed", "vim", "git", "curl", "wget", "diff", "make", "patch", "tar", "lzma", "bzip2", "python", "rsync", "ssh", "screen", "xmllint", "sed", "grep", "top", "ps", "mtr", "dig", "cat", "hexdump", "od", "svn", "cvs", "tail", "less", "w3m"]

import subprocess
import os
import sys

if os.path.split(os.getcwd())[1] != "dotfiles":
   print("This program requires you to be in ~/dotfiles/ when running it")  # because of the call to os.path.abspath
   sys.exit(-1)

symlinks_tmp = {}
for key, value in symlinks.items():
   symlinks_tmp[os.path.abspath(key)] = os.path.expanduser(value)

symlinks = symlinks_tmp

already_exists = [x for x in symlinks.values() if os.path.exists(x)]

if len(already_exists) != 0 and '--force' not in sys.argv:
   print("Some of these paths exist!  Fix the problem (or call with --force)!")
   print(already_exists)
   sys.exit(-1)

if "--delete-existing" in sys.argv:
   [os.remove(x) for x in symlinks.values()]

for direc in [os.path.expanduser(x) for x in dirs.values()]:
   if not os.path.exists(direc):
      print(f"Creating directory {direc}")
      os.mkdir(direc)

for key, value in symlinks.items():
   print(f"Symlinking {key} to {value}...")
   try:
      os.symlink(key, value)
   except OSError:
      if '--force' not in sys.argv:
         raise

subprocess.check_call(["git", "submodule", "init"])
subprocess.check_call(["git", "submodule", "update"])

everything_in_path = [x for x in os.environ["PATH"].split(os.pathsep) if os.path.exists(x) for x in os.listdir(x)]
not_installed = [x for x in utils if x not in everything_in_path]

if len(not_installed) != 0:
   print("These handy utilities are not installed:")
   print(not_installed)

print("All done!")
print("eregex.vim lives in ./vim and is a git submodule.  If you've got vim 7.3 or better you probably want to install it with a make install.")
