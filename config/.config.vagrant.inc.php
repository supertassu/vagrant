<?php
// Provides some sane defaults for the Vagrant install, including database information.
// This file should not be edited, it is simply copied to html/waca/config.local.inc.php,
// edit config/config.local.inc.php instead.

$toolserver_username = "acc";
$toolserver_password = "vagrant";
$toolserver_host = "localhost";
$toolserver_database = "acc";

// Disconnect from IRC notifications and the wiki database.
$ircBotNotificationsEnabled = 0;
$dontUseWikiDb = 1;

$baseurl = "http://127.0.0.1:8081/waca";
$filepath = "/vagrant/html/waca/";
$cookiepath = "/waca/";

// these turn off features which you probably want off for ease of development.
$enableEmailConfirm = 0;
$forceIdentification = false;
$locationProviderClass = "FakeLocationProvider";
$antispoofProviderClass = "FakeAntiSpoofProvider";
$rdnsProviderClass = "FakeRDnsLookupProvider";

$enableSQLError = 1;

$useOauthSignup = false;
$enforceOAuth = false;

require_once('/vagrant/config/config.local.inc.php');
