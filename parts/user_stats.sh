#! /bin/bash

user_stats() {
# Get the current date and calculate the start of the week and month
# date +%u – Returns the current day of week (1-7)
# %d – Day of month (e.g., 01)
# %j – Day of year (001-366)
current_date=$(date +'%Y-%m-%d')
start_of_week=$(date -d "$current_date - $(date +%u) days" +'%Y-%m-%d')
start_of_month=$(date -d "$current_date - $(date +%d) days + 1 day" +'%Y-%m-%d')
start_of_year=$(date -d "$current_date - $(date +%j) days + 1 day" +'%Y-%m-%d')

echo "$current_date, $start_of_week, $start_of_month, $start_of_year"

# Get the number of users in the system
num_users=$(sudo cat /etc/passwd | wc -l)

# Print the report header
echo "Number of Users: $num_users"
echo "Username | Logins This Week | Logins This Month | Logins This Year | Disk Usage"

# Loop through all users
for(( i = 1; i < $num_users + 1; i++ )); do

# sudo last -F --Prints full login and logout times and dates.
# grep "^$username" --Shows only the lines associated with the username. ^ specifies that it must be located at the beginning of the line
# awk -v --Declare a variable
    username=$(awk -F':' '{ print $1}' /etc/passwd | head -n $i | tail -1)

    logins_week=$(sudo last -F | grep "^$username" | awk -v start="$start_of_week" '$6 >= start {count++} END {print count}')
    logins_month=$(sudo last -F | grep "^$username" | awk -v start="$start_of_month" '$6 >= start {count++} END {print count}')
    logins_year=$(sudo last -F | grep "^$username" | awk -v start="$start_of_year" '$6 >= start {count++} END {print count}')

    # If the user has a home directory - print login info and disk usage
    if [ -e /home/"$username" ]; then
        disk_usage=$(sudo du -sh /home/"$username" | cut -f1)
        printf "%-8s | %-16s | %-17s | %-16s | %-10s\n" "$username" "$logins_week" "$logins_month" "$logins_year" "$disk_usage"
    fi

done
sleep 10s
}

user_stats
