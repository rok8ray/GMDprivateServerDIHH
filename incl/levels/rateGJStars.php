<?php
chdir(dirname(__FILE__));
include "../lib/connection.php";
require_once "../lib/GJPCheck.php";
require_once "../lib/exploitPatch.php";
require_once "../lib/mainLib.php";
$gs = new mainLib();
$gjp2check = isset($_POST['gjp2']) ? $_POST['gjp2'] : $_POST['gjp'];
$gjp = ExploitPatch::remove($gjp2check);
$stars = ExploitPatch::remove($_POST["stars"]);
$levelID = ExploitPatch::remove($_POST["levelID"]);
$_postKeys = implode(',', array_keys($_POST));
file_put_contents('/tmp/rate_debug.txt', date('c') . " POST keys: $_postKeys | levelID=" . ($_POST['levelID'] ?? 'MISSING') . " stars=" . ($_POST['stars'] ?? 'MISSING') . "\n", FILE_APPEND);
$accountID = GJPCheck::getAccountIDOrDie();
$permState = $gs->checkPermission($accountID, "actionRateStars");
if($permState){
        $difficulty = $gs->getDiffFromStars($stars);
        $gs->rateLevel($accountID, $levelID, $stars, $difficulty["diff"], $difficulty["auto"], $difficulty["demon"]);
}
echo 1;