# vim: ts=3 et sw=3 sts=3:
import plistlib
import sys
import os
import urllib
import re

stripper = re.compile("^file://localhost(.*)")

#file://localhost/Volumes/ntfs/Music/Music/Apple%20Computer/Developer%20Helper%20Volume%201-%20Phi/07%20Breaking%20Through.mp3

if len(sys.argv) < 3:
   print "Usage: itunes_diff.py iTunes\ Music\ Library.xml /path/to/itunesdir [--ignore-dotfiles]"
   sys.exit()

ignore_dotfiles = False
try:
   if sys.argv[3] == "--ignore-dotfiles":
      ignore_dotfiles = True
except IndexError:
   pass

countdict = plistlib.readPlist(sys.argv[1])

walker = os.walk(sys.argv[2])

hard_drive_paths = set()
itunes_library_paths = set()

for directory in walker:
   for filename in directory[2]:
      hard_drive_paths.add(os.path.join(directory[0], filename))

for track in countdict["Tracks"].iteritems():
   if "Location" in track[1]:
      unquoted = urllib.unquote(track[1]["Location"])
      match = stripper.search(unquoted)
      if match:
         itunes_library_paths.add(match.group(1))

hd_only = hard_drive_paths - itunes_library_paths

for x in hd_only:
   if not ignore_dotfiles:
      print x
   else:
      if not os.path.basename(x).startswith('.'):
         print x

#hopefully there aren't any newlines in your mp3 file names!

