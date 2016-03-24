#!/bin/bash

daydir_basepath="${HOME}/bb7onred"
daydir_today='02 Heute'
rsync_src='remoteuser@remotehost:/path/to/videos/'
rsync_dst="${daydir_today}/videos"

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
## sync
##

if [ ! -d "${daydir_today}" ]; then
	echo "INFO: today-directory '${daydir_today}' does not exist"
	if ! mkdir -p "${daydir_today}"; then
		echo "ERROR: failed to create today-directory '${daydir_today}'" 1>&2
		exit 1
	else
		echo "INFO: successfully created today-directory '${daydir_today}'"
	fi
fi
echo "INFO: syncing today-directory '${daydir_today}' to yesterday-directory '${daydir_yesterday}'"
rsync -e ssh -rtv "${rsync_src}" "${rsync_dst}"
rsync_exit_code="${?}"
case "${rsync_exit_code}" in
	0)
		echo "INFO: successfully finished syncing '${rsync_src}' to '${rsync_dst}'"
		;;
	24)
		echo "NOTICE: some source files vanished during transfer, continuing"
		;;
	*)
		echo "ERROR: rsync failed with exit code ${rsync_exit_code}" 1>&2
		exit 1
		;;
esac

## that's all folks
exit 0
