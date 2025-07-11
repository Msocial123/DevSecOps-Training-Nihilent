#!/bin/bash

# SonarScanner version and installation directory
SONAR_VERSION="5.0.1.3006"
SONAR_DIR="/opt/sonar-scanner"
SONAR_ZIP="sonar-scanner-cli-${SONAR_VERSION}-linux.zip"
SONAR_FOLDER="sonar-scanner-${SONAR_VERSION}-linux"

# Download SonarScanner
echo "Downloading SonarScanner ${SONAR_VERSION}..."
wget "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_ZIP}"

# Unzip the archive
echo "Unzipping ${SONAR_ZIP}..."
unzip -q "$SONAR_ZIP"

# Move to /opt
echo "Moving SonarScanner to ${SONAR_DIR}..."
sudo mv "$SONAR_FOLDER" "$SONAR_DIR"

# Add environment variables to /etc/profile if not already present
echo "Configuring environment variables..."
if ! grep -q "SONAR_SCANNER_HOME" /etc/profile; then
  echo "" | sudo tee -a /etc/profile
  echo "# SonarScanner Environment Variables" | sudo tee -a /etc/profile
  echo "export SONAR_SCANNER_HOME=${SONAR_DIR}" | sudo tee -a /etc/profile
  echo "export PATH=\$PATH:\$SONAR_SCANNER_HOME/bin" | sudo tee -a /etc/profile
fi

# Reload profile to apply changes
echo "Reloading environment variables..."
source /etc/profile

# Check installation
echo "SonarScanner version:"
sonar-scanner -v
