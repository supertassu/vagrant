#!/usr/bin/env bash

# Removes the Vagrant VM and the directories created while
# provisioning it.

read -p "This script will delete the Vagrant virtual machine, the logs directory, and the ACC git repository. Continue? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	vagrant destroy -f
	rm -rf logs
	rm -rf html/waca
fi
