#!/usr/bin/env python
# vim: ts=3 et sw=3 sts=3:
import re
import fileinput
import sys, os

cheatsheet = """You need two args!

pysed.py: regex replacement [file1, file2...]

*: match 0 or more
+: match 1 or more
?: match 0 or 1
*?, +?, ??: non-greedy matching

\d , \D: any digit, any not digit
\s , \S: any whitespace, any not whitespace
\w , \W: any number, letter or _, any not number, letter or _

{n}: match n repetitions
{m,n}: match m to n repetitions

(?iLmsux): one or more chars from set adjust group matching.
   i: ignore case
   L: locale dependent
   m: does not do what you might expect
   s: . also matches newlines
   u: unicode dependent
   x: ignore spaces except when escaped, comments after #
(?:): group can't be backreferenced
(?P<foo>): you can backreference group with \gfoo in substitution or (?P=foo) in regex
(?(backref)regex|regex): ternary if backref exists"""

if len(sys.argv) < 3:
   print >> sys.stderr, cheatsheet
   sys.exit()

regex = re.compile(sys.argv[1])
replacement = sys.argv[2]

sedfiles = []
if len(sys.argv) > 3:
   for sedfile in sys.argv[3:]:
      if os.path.isfile(sedfile):
         sedfiles.append(sedfile)

for line in fileinput.input(sedfiles):
   sys.stdout.write(re.sub(regex, replacement, line))
