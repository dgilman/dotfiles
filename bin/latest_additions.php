<?php

if ($_GET['id'] == NULL)
{
   print "You really meant to do something like latest_additions.php?id=SOMETHING_RANDOM_ANYTHING_WILL_DO_REALLY";
   return;
}

$current_time = time();
$filename = "rss_" . basename($_GET['id']);

if (file_exists($filename))
{
   $state_file = file_get_contents($filename);
   $state = unserialize($state_file);
   if ($state['time']+12*60*60 < $current_time)
   {
      $new_bugs = get_list();
      $bug_difference = bug_diff($state['list'], $new_bugs, $state['count']);
      
      if (count($bug_difference != 0))
      {
         print_rss($bug_difference);
      }
      else //no new bugs
      {
         print_rss($state['diff']);
      }

      $state['time'] = $current_time;
      $state['list'] = $new_bugs;
      $state['diff'] = $bug_difference;
      save_state($state);
   }
   else
   {
      print_rss($state['diff']);
   }
}
else //new user!  come back in 12 hours hokay
{
   $state = array();
   $state['time'] = $current_time;
   $state['list'] = get_list();
   $state['diff'] = array();
   $state['count'] = get_count();
   save_state($state);
}

function print_rss($items)
{
   print '<?xml version="1.0" encoding="utf-8"?>';
   print '<rss version="2.0">';
   print '<channel>';
   print '<title>Firefox 4 blocker updates</title>';
   print '<link>http://gilslotd.com</link>';
   print '<description>The latest additions and deletions from the Firefox 4 blockers.</description>';
   foreach ($items as $bug => $summary)
   {
      print '<item>';
      print '<title> Bug ' . $bug . ': ' . $summary . '</title>';
      print '<link>http://bugzilla.mozilla.org/' . $bug . '</link>';
      print '<description>' . $summary . '</description>';
      print '<guid>' . $bug . $description . '</guid>';
      print '</item>';
   }
   print '</channel></rss>';
}

function bug_diff($old, $new, $old_count) 
{
   $deletions = array_diff_key($old, $new);
   $additions = array_diff_key($new, $old);

   $result = array();
   foreach ($deletions as $bug => $summary)
   {
      $result[$bug] = htmlentities('<div style="color:red;display:inline">No longer blocking: </div>') . $summary;
   }
   foreach ($additions as $bug => $summary)
   {
      $result[$bug] = htmlentities('<div style="color:green;display:inline">Newly blocking: </div>') . $summary;
   }
   $new_count = get_count();
   if (count($result) != 0)
   {
      if ($old_count - $new_count > 0)
      {
         $result["Summary"] = "We lost " . $old_count - $new_count . " bugs.";
      }
      else
      {
         $result["Summary"] = "We gained " . $old_count - $new_count . " bugs.";
      }
   }
   return $result;
}

function get_count()
{
   $query_url = "https://api-dev.bugzilla.mozilla.org/latest/count?cf_blocking_20=final&status=REOPENED&status=NEW&status=ASSIGNED&status=UNCONFIRMED&cf_blocking_20=beta&cf_blocking_20_type=contains_any";
   $curl_obj = curl_init();
   curl_setopt($curl_obj, CURLOPT_URL, $query_url);
   curl_setopt($curl_obj, CURLOPT_RETURNTRANSFER, TRUE);
   $buglist_json = curl_exec($curl_obj);
   return json_decode($buglist_json)->data;
}

function get_list()
{
   $query_url = "https://api-dev.bugzilla.mozilla.org/latest/bug?cf_blocking_20=final&status=REOPENED&status=NEW&status=ASSIGNED&status=UNCONFIRMED&cf_blocking_20=beta&cf_blocking_20_type=contains_any&include_fields=id,summary";
   $curl_obj = curl_init();
   curl_setopt($curl_obj, CURLOPT_URL, $query_url);
   curl_setopt($curl_obj, CURLOPT_RETURNTRANSFER, TRUE);

   $buglist_json = curl_exec($curl_obj);
   $json_list = json_decode($buglist_json);
   $array_list = array();

   foreach ($json_list->bugs as $bug)
   {
      $array_list[$bug->id] = $bug->summary;
   }
   return $array_list;
}

function save_state($state)
{
   global $filename;
   file_put_contents($filename, serialize($state));
}
?>
