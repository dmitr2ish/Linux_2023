#!/bin/bash

# creating users with checking errors
add_user_with_home() {
  sudo useradd -m -p $(openssl passwd -1 "$1") "$2" || { echo "Failed to create user $2"; exit 1; }
}

add_user_with_home "123321" John
add_user_with_home "321123" Daisy
add_user_with_home "332211" Michael

# creating groups
sudo groupadd project_john
sudo groupadd project_main

# adding users to our groups
sudo usermod -a -G project_john John
sudo usermod -a -G project_main Daisy
sudo usermod -a -G project_main Michael

# updating package
sudo apt update
sudo apt install -y -qq python3.10-venv

# creating project directories
project_john_dir=/tmp/John_App
project_main_dir=/tmp/Application_Main

sudo mkdir $project_john_dir $project_main_dir

# set permissions for access to dirs
sudo chown John:project_john $project_john_dir
sudo chmod 2770 $project_john_dir

sudo chown :project_main $project_main_dir
sudo chmod 2770 $project_main_dir

# set virtual env in project dir
sudo -u John python3 -m venv $project_john_dir/venv
sudo python3 -m venv $project_main_dir/venv

# configure permission for project main dir
sudo chown -R :project_main $project_main_dir/venv
sudo chmod -R 2775 $project_main_dir/venv

# activating of env and installing packages
sudo -u John bash -c 'source '$project_john_dir'/venv/bin/activate && pip install numpy'
sudo -u Michael bash -c 'source '$project_main_dir'/venv/bin/activate && pip install requests'

john_script_name=$project_john_dir/venv/john.py
main_script_name=$project_main_dir/venv/main.py

# building script for john project
echo "import numpy as np
array = np.random.rand(10)
print(array)" | sudo tee $john_script_name

echo "import requests
response = requests.get('https://urfu.ru/ru')
print(response.headers)" | sudo tee $main_script_name

# checking
checking_prepared_work_space() {
   echo "$1 login and start his script"
   sudo -u "$1" bash -c 'python3 '"$2" || { echo "Failed to check user $1"; exit 1; }
}

checking_prepared_work_space John $john_script_name
checking_prepared_work_space Daisy $main_script_name
checking_prepared_work_space Michael $main_script_name

echo "Workspace prepared successfully"