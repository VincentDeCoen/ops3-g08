<?php
$link = mysql_connect('192.168.56.59', 'wordpress_usr', '1OjejAfPod');
if (!$link) {
die('Could not connect: ' . mysql_error());
}
mysql_select_db('wordpress_db') or die ('No database found');
echo 'Connected successfully';
mysql_close($link);
?>