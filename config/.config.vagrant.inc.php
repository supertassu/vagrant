<?php
// Provides some sane defaults for the Vagrant install, including database information.
// This file should not be edited, it is simply copied to html/waca/config.local.inc.php,
// edit config/config.local.inc.php instead.

$toolserver_username = "root";
$toolserver_password = "vagrant";
$toolserver_host = "localhost";
$toolserver_database = "acc";

$dontUseWikiDb = 1;
$useOauthSignup = false;
$enforceOAuth = false;

$baseurl = "http://127.0.0.1:8081/waca";
$filepath = "/vagrant/html/waca/";
$cookiepath = "/waca/";

$enableEmailConfirm = 0;
$onRegistrationNewbieCheck = false;
$forceIdentification = false;

$enableSQLError = 1;

$ircBotNotificationsEnabled = 0;

require_once('/vagrant/config/config.local.inc.php');
