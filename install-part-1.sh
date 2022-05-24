#!/bin/sh
# Update and upgrade packages, to get up-to-date packages
sudo apt update -y && sudo apt upgrade -y
# Restart the machine
sudo reboot