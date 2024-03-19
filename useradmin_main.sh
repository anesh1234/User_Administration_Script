#! /bin/bash

mainmenu() {
	clear
    echo -ne "
MAIN MENU
1) Info About User
2) Add User
3) Reset User Password
4) User Stats
0) Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        bash parts/info_about_user.sh
        ;;
	2)
        bash parts/add_user.sh
        ;;
	3)
        bash parts/reset_user_password.sh
        ;;
	4)
        bash parts/user_stats.sh
        ;;
    0)
        echo "Bye bye."
        exit 0
        ;;
    *)
        echo "Unavailable Option, Quitting"
		exit 1
        ;;
    esac
sleep 3s
mainmenu
}

mainmenu
