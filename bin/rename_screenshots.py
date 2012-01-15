import os
import re
import sys
import datetime

matcher = re.compile('^Picture \d*\.png$')

for files in os.walk(sys.argv[1]):
    for filename in files[2]:
            matchobj = re.match(matcher, filename)
            if matchobj:
               filepath = os.path.join(files[0], filename)
               mtime = datetime.datetime.fromtimestamp(os.stat(filepath).st_mtime)
               newname = os.path.join(files[0], mtime.strftime("Screenshot %Y-%m-%d %H:%M:%S.png"))
               os.rename(filepath, newname)

