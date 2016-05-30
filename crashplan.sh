#!/bin/bash

LOCAL="local"
LOCALHOSTPROPS="localhost.ui_info"
RC01="172.16.1.20"
RC01PROPS="rc01.ui_info"
UIPROPSLOC="/Library/Application Support/CrashPlan/.ui_info"
CPAPP="/Applications/CrashPlan.app/"

function delete_crashplan_ui_properties {
	echo "Removing current ui.properties."
	rm -rf ${UIPROPSLOC}
}

function copy_new_crashplan_conf {
	echo "Copying $1 to CrashPlan conf."
	sudo cp $1 "${UIPROPSLOC}"
}

function open_crashplan {
	open -a ${CPAPP}
}

function run_rc01_config {
    echo "Starting CrashPlan UI with rc01 configuration."
	copy_new_crashplan_conf ${RC01PROPS}
	ssh -nNT -L 4200:localhost:4243 root@${RC01} &
	open_crashplan
}

function run_localhost_config {
    echo "Starting CrashPlan UI with localhost configuration"
	copy_new_crashplan_conf ${LOCALHOSTPROPS}
	open_crashplan
}

if [ "$1" = ${RC01}  ]; then
	run_rc01_config
elif [ "$1" = ${LOCAL} ]; then
	run_localhost_config
else
	run_rc01_config
fi
