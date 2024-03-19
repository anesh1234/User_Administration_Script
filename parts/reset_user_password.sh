#! /bin/bash

reset_password(){
	echo -ne "Provide Username: "
	read -r ans
	echo -ne "Provide Username: "
	read -r mail
	new_password=$ans$(date| tr -d '[:blank:]')

	# Set new password and force changing
	echo "$ans:$new_password" | sudo chpasswd
	sudo passwd -e $ans

	# Mail the new password to the user
	echo "Your new password is $new_password" | mail -s "From Sysadmin" $mail
	
	echo -ne "Do you wish to quit/do again? y/n: "
	read -r ans
	if [[ "$ans" == "Y" ]] || [[ "$ans" == "y" ]]; then
		exit 0
	else
		reset_password
		exit 0
	fi
}

reset_password