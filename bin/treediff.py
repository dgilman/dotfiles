import hashlib
import os
import sys

def make_set(directory):
   dir_dict = {}
   for files in os.walk(directory):
      for f in files[2]:
         hasher = hashlib.sha1()
         file_path = os.path.join(files[0], f)
         contents = open(file_path)
         hasher.update(contents.read())
         dir_dict[hasher.digest()] = file_path

   dir_set = set(dir_dict.iterkeys()) 
   return dir_dict, dir_set
 
dir_a_dict, dir_a_set = make_set(sys.argv[1])
dir_b_dict, dir_b_set = make_set(sys.argv[2])

only_a = dir_a_set - dir_b_set
only_b = dir_b_set - dir_a_set

print "Left hand:"
for f in only_a:
   print dir_a_dict[f]

print "Right hand:"
for f in only_b:
   print dir_b_dict[f]
