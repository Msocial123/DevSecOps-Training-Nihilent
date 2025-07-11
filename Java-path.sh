#!/bin/bash

# Install Amazon Corretto 11
echo "Installing Amazon Corretto 11..."
sudo yum install java-11-amazon-corretto -y

# Show alternatives and let user configure manually (optional)
echo "Configuring default Java (optional)..."
sudo alternatives --config java

# Find top 3 JDK paths for manual inspection
echo "Top 3 JDK paths found:"
JDK_PATHS=$(find /usr/lib/jvm/java-11* 2>/dev/null | head -n 3)
echo "$JDK_PATHS"

# Get the second line from the paths found
JAVA_HOME_PATH=$(echo "$JDK_PATHS" | sed -n '2p')

# If second line exists, use it; otherwise, fallback to known path
if [ -z "$JAVA_HOME_PATH" ]; then
  JAVA_HOME_PATH="/usr/lib/jvm/java-11-amazon-corretto.x86_64"
  echo "Falling back to default: $JAVA_HOME_PATH"
else
  echo "Using JAVA_HOME: $JAVA_HOME_PATH"
fi

# Create jdk.sh to set environment variables
echo "Setting JAVA_HOME in /etc/profile.d/jdk.sh..."
echo "export JAVA_HOME=${JAVA_HOME_PATH}" | sudo tee /etc/profile.d/jdk.sh > /dev/null
echo "export PATH=\$JAVA_HOME/bin:\$PATH" | sudo tee -a /etc/profile.d/jdk.sh > /dev/null

# Apply changes
echo "Applying new JAVA_HOME..."
source /etc/profile.d/jdk.sh

# Confirm Java version
echo "Java version:"
java -version
