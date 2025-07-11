#!/bin/bash

# install_sonarqube.sh - SonarQube 9.6.1 setup script for RHEL/Amazon Linux
# Prerequisites: Run as root user

set -e  # Exit on error

echo " Updating system packages..."
yum update -y

echo "Installing Java 11 (required by SonarQube)..."
yum install java-11-openjdk-devel -y

echo "Installing wget and unzip..."
yum install wget unzip -y

echo "Navigating to /opt and downloading SonarQube..."
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.6.1.59531.zip

echo "Unzipping and renaming SonarQube directory..."
unzip sonarqube-9.6.1.59531.zip
mv sonarqube-9.6.1.59531 sonarqube

echo "👤 Creating sonar user..."
useradd sonar

echo "Granting sudo access to sonar user..."
if ! grep -q "^sonar" /etc/sudoers; then
    echo "sonar   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
fi

echo "Setting permissions on /opt/sonarqube..."
chown -R sonar:sonar /opt/sonarqube/
chmod -R 775 /opt/sonarqube/

echo "Switching to sonar user and starting SonarQube..."
su - sonar -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"

echo "SonarQube started successfully. Access it at: http://<your-server-ip>:9000"
