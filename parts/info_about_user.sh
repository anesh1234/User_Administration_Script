#! /bin/bash

info_about_user() {
	clear
    echo -ne "
CHOOSE RELEVANT INFO
1) Last Login
2) Disk Usage
3) Back to Main Menu
Choose an option:  "
    read -r ans
    case $ans in
    1)
		last_login
        ;;
    2)
        disk_usage
        ;;
	3)
		exit 1
		;;
    *)
        echo "Unavailable Option, Quitting"
		exit 1
        ;;
    esac
}


last_login(){
	echo -ne "Provide Username: "
	read -r ans
	lastlog -u $ans
	
	echo -ne "Do you wish to quit? y/n: "
	read -r ans
	if [[ "$ans" == "Y" ]] || [[ "$ans" == "y" ]]; then
		exit 0
	else
		info_about_user
	fi
}

disk_usage(){
	echo -ne "Provide Username: "
	read -r ans
	sudo du -sh /home/$ans
	
	echo -ne "Do you wish to quit? y/n: "
	read -r ans
	if [[ "$ans" == "Y" ]] || [[ "$ans" == "y" ]]; then
		exit 0
	else
		info_about_user
	fi
}

info_about_user
