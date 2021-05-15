#!/bin/bash
#
# script for setting up termux (the android app) because i'm a lazy dog
#
# if you uninstall and reinstall termux your termux environment is gone, just fyi fren
#
# ty termux, it's a really awesome app 💙
#
# termux:		https://termux.com/
# f-droid termux page:	https://f-droid.org/repository/browse/?fdid=com.termux 
#
# github.com/tojathedog 🐶


# options###

# set packages_list as you like! these will be installed
declare -a packages_list=(
python
vim
wget
openssh
termux-tools
)

# option of where to start termux (i like downloads folder, you can change this)
#startup_dir='~/storage/downloads'

# bash opts ###
set -o nounset
set -o pipefail



# util functions ###

# nl - print a new line please
nl() { printf "\n"; }

# err - func for printing out broken parts
err() { 
	echo "$1 $*" >&2
	exit 1
}

# usage - show how to use this script
usage() { cat <<USAGEEND
usage:

-h    print this help
-v    show output of each step
-t    do only termux-related setup tasks, like setup storage access

USAGEEND
}
	


# args ###
verbose='off'
termux_setup_only='off'

while getopts 'hvt' flags; do
	case "${flags}" in
		h) usage ;;
		v) verbose='on' ;;
		t) termux_setup_only='on' ;;
		*) usage
		   err "unknown option" ;;
	esac
done


# vars check and set start ###
readonly packages_list
readonly verbose
readonly termux_setup_only
#readonly startup_dir

# setup start! ### 
nl;

echo "termux_setup start!"
setup_step=1

nl;

echo "setup step ${setup_step} - upgrade packages"; nl;
echo -n "updating packages with pkg upgrade...";
if [[ "${verbose}" == 'off' ]] ; then
	echo pkg upgrade;
elif [[ "${verbose}" == 'on' ]] ; then
	echo pkg upgrade with stuff on the output;
else
	err "can't update packages";
fi 
echo "DONE!"; (( setup_step += 1 )); nl;

if [[ "${termux_setup_only}" == 'off' ]] ; then
echo "setup step ${setup_step} - install packages"; nl;
if [[ "${packages_list[@]:+${packages_list[@]}}" ]]; then
	echo -n "installing the following packages: "${packages_list[@]}"... "
	if [[ "${verbose}" == 'off' ]] ; then
		echo pkg add "${packages_list[@]}";
	elif [[ "${verbose}" == 'on' ]] ; then
		echo pkg add "${packages_list[@]}" with stuff on the output;
	else
		err "can't install the packages you wanted";
	fi
else
	echo "no packages in packages_list setting, skipping this part!"; nl;

fi
echo "DONE!"; (( setup_step += 1 )); nl;
fi

echo "setup step ${setup_step} - setup local storage"; nl;
echo -n "running termux-storage-setup..."
echo termux-setup-storage && echo "DONE!" || err "can't set up termux-storage-setup"; nl;

echo "termux_setup.sh complete!"; nl;
