import pytz
import datetime

print "Continent/City"

while True:
   try:
      tz1 = pytz.timezone(raw_input("Timezone 1 > "))
      break
   except:
      pass

while True:
   try:
      tz2 = pytz.timezone(raw_input("Timezone 2 > "))
      break
   except:
      pass

while True:
   try:
      t = tz1.localize(datetime.datetime.strptime(raw_input("Timestamp Y/M/D H:M:S %p> "), "%Y/%m/%d %I:%M:%S %p"))
      break
   except:
      pass

print (tz2.normalize(t.astimezone(tz2))).strftime("%Y/%m/%d %I:%M:%S %p")

