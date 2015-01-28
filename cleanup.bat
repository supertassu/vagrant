:: Removes the Vagrant VM and the directories created while
:: provisioning it.

@echo off
set /P REPLY=This script will delete the Vagrant virtual machine, the logs directory, and the ACC git repository. Continue? 
if /i {%REPLY%}=={y} (goto :y)
if /i {%REPLY%}=={Y} (goto :y)
exit
:y
vagrant destroy -f
rmdir logs /s /q
rmdir html\waca /s /q
