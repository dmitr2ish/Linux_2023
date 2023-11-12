#!/bin/bash

# Removing user and their home dirs
delete_user_and_home() {
  sudo deluser --remove-home "$1" || { echo "Failed removing user $1"; exit 1; }
}

delete_user_and_home "John"
delete_user_and_home "Daisy"
delete_user_and_home "Michael"

# Removing groups
delete_group() {
  sudo delgroup "$1" || { echo "Failed removing group $1"; exit 1; }
}

delete_group "project_john"
delete_group "project_main"

# Removing dirs
delete_project_dir() {
  sudo rm -rf "$1" || { echo "Failed removing dirs $1"; exit 1; }
}

delete_project_dir "/tmp/John_App"
delete_project_dir "/tmp/Application_Main"

echo "Users and groups removed. Directories cleaned."
