#!/usr/bin/python

import json
import urllib
import datetime
import subprocess
import sqlite3
import numpy
import time

bookmarks = json.load(open("/Users/david/Library/Application Support/Google/Chrome/Default/Bookmarks"))

chrome = 0
for subfolder in bookmarks["roots"]["other"]["children"]:
   if subfolder["name"] == "special lotd":
      chrome = len(subfolder["children"])
      break

website = int(urllib.urlopen("http://gilslotd.com/count.php").read())

#fd = open("/Users/david/bin/links.csv", 'a')
#fd.write("%s,%d,%d\n" % (datetime.date.today().isoformat(),chrome,website))
#fd.close()

connection = sqlite3.connect("/Users/david/bin/lotdstats.sqlite3", detect_types=sqlite3.PARSE_DECLTYPES|sqlite3.PARSE_COLNAMES)
c = connection.cursor()

c.execute("insert into lotdstats (ts, bookmarks, queue) values (?, ?, ?)", (datetime.datetime.now(), chrome, website))
connection.commit()

fd = open("/Users/david/bin/links.json", "w+")

series = [{"name": "Links in browser boomarks", "data":[]}, {"name":"Links queued on website", "data":[]}, {"name": "Total links", "data":[]}]

c.execute("select * from lotdstats;")

for log in c.fetchall():
   series[0]["data"].append([log[0].isoformat(), log[1]])
   series[1]["data"].append([log[0].isoformat(), log[2]])
   series[2]["data"].append([log[0].isoformat(), log[1]+log[2]])

#stats
#split bookmarks folder into increasing, decreasing bits.
def splitter(data, k):
   rval = []
   increasing = None
   if k(data[0]) > k(data[1]):
      increasing = False
   if k(data[0]) < k(data[1]):
      increasing = True
   for index, point in enumerate(data):
      if len(rval) == 0:
         rval.append(point)
      if k(point) == k(rval[-1]):
         rval.append(point)
      if k(point) > k(rval[-1]):
         if increasing is True: #were increasing, still increasing
            rval.append(point)
         if increasing is False: #were decreasing, now increasing
            yield rval, increasing
            increasing = True
            rval = []
            rval.append(point)
      if k(point) < k(rval[-1]):
        if increasing is False: #were decreasing, still decreasing
            rval.append(point)
        if increasing is True: #were increasing, no logner increasing
            yield rval, increasing
            increasing = False
            rval = [] #when we return, reset rval and start a new list with the first decreaser
            rval.append(point)
      if len(data) == index+1:
         yield rval, increasing

def epoch_days(ts):
   if '.' in ts: #strip fractional seconds
      ts = ts.partition('.')[0]
   return time.mktime(datetime.datetime.strptime(ts, "%Y-%m-%dT%H:%M:%S").timetuple())/86400

#get list of runs
runs = [x for x in splitter(series[0]["data"], lambda x: x[1])]
increasing = [x[0] for x in runs if x[1] is True]
decreasing = [x[0] for x in runs if x[1] is False]


#find average of decreasers

paired_runs = zip(increasing, decreasing)
average_drop = numpy.average([numpy.true_divide(x[1][0][1], x[0][-1][1]) for x in paired_runs])
#x[0][-1][1] is increasers, last measured value, qty

#find slope of increasers.  get lists of their xs, ys first
individual_regressions = []
for increaser in increasing:
   increasing_arr_y = numpy.array([x[1] for x in increaser])
   increasing_arr_x = numpy.array([epoch_days(x[0]) for x in increaser])
#that's days since 1970... using seconds appears to introduce rounding errors because mktime deals with floats (???)

   A = numpy.vstack([increasing_arr_x, numpy.ones(len(increasing_arr_x))]).T
   regression_bits = numpy.linalg.lstsq(A, increasing_arr_y)[0]
   individual_regressions.append(regression_bits) #a tuple (slope, intercept)

#average out runs
averaged_slope = numpy.average([x[0] for x in individual_regressions])
#use the first slope's intercept from here on out.. the reasoning is because we always base the regressions on the first data point.
intercept = individual_regressions[0][1]

#multiplying by average drop % and 1 for the one per day depletion
regression_slope =  (averaged_slope*average_drop) - 1

# regression_foo  uses the total regression (incl average drop), orig_regression_foo is rate of adding 
regression_x_0 = epoch_days(series[0]["data"][0][0])
regression_y_0 = regression_x_0*averaged_slope + intercept

#y_1 will be 0
regression_intercept = regression_y_0 - (regression_slope*regression_x_0)
regression_x_1 = numpy.true_divide(-regression_intercept, regression_slope)

orig_regression_y_0 = epoch_days(series[0]["data"][0][0])*averaged_slope+intercept
orig_regression_y_1 = epoch_days(series[0]["data"][-1][0])*averaged_slope+intercept

#series.append({"name": "Average rate of lotd adding", "data": [[series[0]["data"][0][0], orig_regression_y_0], [series[0]["data"][-1][0], orig_regression_y_1]]})

if regression_slope < 0: #if not, we increase indefinitely
   try:
      series.append({"name": "Average rate including average transfer loss", "data": [[series[0]["data"][0][0], regression_y_0], [datetime.datetime.fromtimestamp(regression_x_1*86400).isoformat(), 0]]})
      series[0]["ridealong"] = datetime.datetime.fromtimestamp(regression_x_1*86400).isoformat()
   except: #sometimes a date is bigger than time_t...
      series[0]["ridealong"] = "Really, really far off in the future.  Probably after 2038.  (bigger than the system's time_t)" #TODO: structure this
else: #infinite increase
   series[0]["ridealong"] = "Infinite increase!"

json.dump(series, fd)

fd.close()
connection.close()

subprocess.call(["/usr/bin/scp", "/Users/david/bin/links.json", "david@dgilman.xen.prgmr.com:~/apache/"])
