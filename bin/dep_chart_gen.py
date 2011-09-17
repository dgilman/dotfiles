#!/usr/bin/python

import subprocess
import re

dep_re = re.compile("(\w*?) Dependencies:\s*?(.*)$")

installed = subprocess.check_output(["port", "installed"]).splitlines()
active = [x.strip()[:-9].split(' ') for x in installed if '(active)' in x]

dep_list = []
for port in active:
   info = subprocess.check_output(["port", "info", port[0], port[1]]).splitlines()
   for line in info:
      goodline = re.findall(dep_re, line)
      if goodline:
         #                portname         deptype                 deplist
         dep_list.append([port[0].strip(), goodline[0][0].strip(), goodline[0][1].rsplit(", ")])


#['yasm', 'Library', ['gettext']]
print "digraph G {"
for port in active:
   print '"' + port[0] + '";'
for port in dep_list:
   for dep in port[2]:
      print '"' + port[0] + '" -> "' + dep.strip() + '" [label="' + port[1] + '"];'
print "}"
