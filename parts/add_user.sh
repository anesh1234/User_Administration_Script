#! /bin/bash

add_user() {
	clear
	echo -ne "Provide Username:  "
	read -r username

	if getent passwd "$username" &>/dev/null; then
		echo 'User already exists, returning'
		sleep 3s
		return 0
	else
		echo "User $username does not exist, would you like to create it? y/n"
		read -r ans
	fi

	if [[ "$ans" == "Y" ]] || [[ "$ans" == "y" ]]; then
		create_user "$username"
    else
		echo 'Opted out, returning'
		sleep 3s
        return 0
    fi

}

create_user() {
	clear
	echo -ne "Enter full name: "
	read -r full_name
	echo -ne "Enter email: "
	read -r email
	echo -ne "Enter main group name: "
	read -r main_group
	echo -ne "Enter up to two additional groups (whitespace separated): "
	read -r add_group1 add_group2

	Groups=("$main_group" "$add_group1" "$add_group2")

	# Create an ok first-time password
	date=$(date| tr -d '[:blank:]')
	user_password="$1$date"


	# # Verification of variables
	# echo "Username: $1 Full name: $full_name email: $email"
	# echo "Main group: $main_group Additional groups: $add_group1 $add_group2"
	# echo "Password: $user_password"
	# echo "GroupID: $groupId"

	# for i in ${Groups[*]}; do
	# 	echo "$i"
	# done


	for i in ${Groups[*]}; do
		if [ -z $i ]; then
			continue
		fi
		if [ -n $(getent group $i) ]; then
			echo "The group $i exists."
		else
			echo "The group $i does not exist, would you like to create it? y/n"
			read -r ans
			if [[ "$ans" == "Y" ]] || [[ "$ans" == "y" ]]; then
				sudo groupadd $i
			else
				echo "None added."
			fi
		fi
	done

	groupId="$(getent group "$main_group" | cut -d: -f3)"

	if [ -z "$add_group1" ]; then
			sudo useradd -c "$full_name","$email" -g "$groupId" -s /bin/bash -m -d /home/$1 -k /home/kali/skel_dir $1
	else
		if [ -z "$add_group2" ]; then
			sudo useradd -c "$full_name","$email" -g "$groupId" -G "$add_group1" -s /bin/bash -m -d /home/$1 -k /home/kali/skel_dir $1
		else
			sudo useradd -c "$full_name","$email" -g "$groupId" -G "$add_group1","$add_group2" -s /bin/bash -m -d /home/$1 -k /home/kali/skel_dir $1
		fi
	fi

	# Set password and force changing of password on next logon
	sudo echo $user_password | passwd $1
	sudo passwd -e $1

	# Add the user to the accounting database
	sudo systemctl start mysql
	sudo mysql -e "INSERT INTO Accounting.Accounting VALUES ('$1','$full_name','$email')"
	sudo mysql -e "select * from Accounting.Accounting where (username='$1');"

	send_mail "$1" "$user_password" "$email"
}


send_mail() {
	mail_message="Hello. Your username is $1, and your password is $2, although you must change this on first logon. To use ssh you must enable google authenticator by typing "google-authenticator", then reply yes to all prompts. You must then install the google authenticator app on your phone and scan the QR code. Remember to store your emergency scratch codes somewhere safe."
	echo "$mail_message" | mail -s "New User Welcome Message" $3
}

add_user
