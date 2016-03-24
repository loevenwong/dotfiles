#!/bin/bash

daydir_basepath="/srv/tagesordner"
daydir_tomorrow="${daydir_basepath}/01Morgen"
daydir_today="${daydir_basepath}/02Heute"
daydir_yesterday="${daydir_basepath}/03Gestern"
daydir_backup="${daydir_basepath}/04Backup/$(date --date='yesterday' '+%Y/%m/%d')"

if [ ! -d "${daydir_basepath}" ]; then
	echo "INFO: basepath-directory '${daydir_basepath}' does not exist"
	if ! mkdir -p "${daydir_basepath}"; then
		echo "ERROR: failed to create basepath-directory '${daydir_basepath}'" 1>&2
		exit 1
	else
		echo "INFO: successfully created basepath-directory '${daydir_basepath}'"
	fi
fi

##
## yesterday -> backup
##

if [ ! -d "${daydir_backup}" ]; then
	echo "INFO: backup-directory '${daydir_backup}' does not exist"
	if ! mkdir -p "${daydir_backup}"; then
		echo "ERROR: failed to create backup-directory '${daydir_backup}'" 1>&2
		exit 1
	else
		echo "INFO: successfully created backup-directory '${daydir_backup}'"
	fi
fi
if [ ! -d "${daydir_yesterday}" ]; then
	echo "INFO: yesterday-directory '${daydir_yesterday}' does not exist"
	if ! mkdir -p "${daydir_yesterday}"; then
		echo "ERROR: failed to create yesterday-directory '${daydir_yesterday}'" 1>&2
		exit 1
	else
		echo "INFO: successfully created yesterday-directory '${daydir_yesterday}'"
	fi
else
	echo "INFO: syncing yesterday-directory '${daydir_yesterday}' to backup-directory '${daydir_backup}'"
	rsync -rtv "${daydir_yesterday}/" "${daydir_backup}/"
	rsync_exit_code="${?}"
	case "${rsync_exit_code}" in
		0)
			echo "INFO: successfully finished syncing yesterday-directory '${daydir_yesterday}' to backup-directory '${daydir_backup}'"
			;;
		24)
			echo "NOTICE: some source files vanished during transfer, continuing"
			;;
		*)
			echo "ERROR: rsync failed with exit code ${rsync_exit_code}" 1>&2
			exit 1
			;;
	esac
	echo "INFO: clearing yesterday-directory '${daydir_yesterday}'"
	if ! find "${daydir_yesterday}/" -mindepth 1 -print0 | xargs -0 -r rm -rf; then
		echo "ERROR: failed clearing yesterday-directory '${daydir_yesterday}'" 1>&2
		exit 1
	fi
fi

##
## today -> yesterday
##

if [ ! -d "${daydir_today}" ]; then
	echo "INFO: today-directory '${daydir_today}' does not exist"
	if ! mkdir -p "${daydir_today}"; then
		echo "ERROR: failed to create today-directory '${daydir_today}'" 1>&2
		exit 1
	else
		echo "INFO: successfully created today-directory '${daydir_today}'"
	fi
else
	echo "INFO: syncing today-directory '${daydir_today}' to yesterday-directory '${daydir_yesterday}'"
	rsync -rtv "${daydir_today}/" "${daydir_yesterday}/"
	rsync_exit_code="${?}"
	case "${rsync_exit_code}" in
		0)
			echo "INFO: successfully finished syncing today-directory '${daydir_today}' to yesterday-directory '${daydir_yesterday}'"
			;;
		24)
			echo "NOTICE: some source files vanished during transfer, continuing"
			;;
		*)
			echo "ERROR: rsync failed with exit code ${rsync_exit_code}" 1>&2
			exit 1
			;;
	esac
	echo "INFO: clearing today-directory '${daydir_today}'"
	if ! find "${daydir_today}/" -mindepth 1 -print0 | xargs -0 -r rm -rf; then
		echo "ERROR: failed clearing today-directory '${daydir_today}'" 1>&2
		exit 1
	fi
fi

##
## tomorrow -> today
##

if [ ! -d "${daydir_tomorrow}" ]; then
	echo "INFO: tomorrow-directory '${daydir_tomorrow}' does not exist"
	if ! mkdir -p "${daydir_tomorrow}"; then
		echo "ERROR: failed to create tomorrow-directory '${daydir_tomorrow}'" 1>&2
		exit 1
	else
		echo "INFO: successfully created tomorrow-directory '${daydir_tomorrow}'"
	fi
else
	echo "INFO: syncing tomorrow-directory '${daydir_tomorrow}' to today-directory '${daydir_today}'"
	rsync -rtv "${daydir_tomorrow}/" "${daydir_today}/"
	rsync_exit_code="${?}"
	case "${rsync_exit_code}" in
		0)
			echo "INFO: successfully finished syncing tomorrow-directory '${daydir_tomorrow}' to today-directory '${daydir_today}'"
			;;
		24)
			echo "NOTICE: some source files vanished during transfer, continuing"
			;;
		*)
			echo "ERROR: rsync failed with exit code ${rsync_exit_code}" 1>&2
			exit 1
			;;
	esac
	echo "INFO: clearing tomorrow-directory '${daydir_tomorrow}'"
	if ! find "${daydir_tomorrow}/" -mindepth 1 -print0 | xargs -0 -r rm -rf; then
		echo "ERROR: failed clearing tomorrow-directory '${daydir_tomorrow}'" 1>&2
		exit 1
	fi
fi
## create empty structure
if ! mkdir -p "${daydir_tomorrow}/videos"; then
	echo "ERROR: failed creating tomorrow-video-directory '${daydir_tomorrow}/videos'" 1>&2
	exit 1
fi
for i in $(seq -f %02g 1 8); do
	if ! mkdir -p "${daydir_tomorrow}/story${i}/images"; then
		echo "ERROR: failed creating tomorrow-story${i}-images-directory '${daydir_tomorrow}/story${i}/images'" 1>&2
		exit 1
	fi
done

## that's all folks
exit 0
