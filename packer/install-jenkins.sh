#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get upgrade -y
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list

# Installing Java 11
echo "================================="
echo "Installing Java 17"
echo "================================="
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jre
/usr/bin/java --version

# Add Jenkins Repository
echo "================================="
echo "Adding Jenkins Repository, install Jenkins"
echo "================================="
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y


# Install Jenkins Plugins
echo "================================="
echo "Installing Jenkins Plugins"
echo "================================="
wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.13/jenkins-plugin-manager-2.12.13.jar
sudo chmod +x jenkins-plugin-manager-2.12.13.jar
sudo java -jar jenkins-plugin-manager-2.12.13.jar --war /usr/share/java/jenkins.war --plugin-file /tmp/plugins.txt --plugin-download-directory /var/lib/jenkins/plugins/
sudo chmod +x /var/lib/jenkins/plugins/*.jpi

echo "================================="
echo "Placing Jenkins CASC Files"
echo "================================="
sudo cp /tmp/casc.yaml /var/lib/jenkins/casc.yaml
sudo cp /tmp/job-dsl.groovy /var/lib/jenkins/job-dsl.groovy
sudo chmod +x /var/lib/jenkins/casc.yaml /var/lib/jenkins/job-dsl.groovy
(cd /var/lib/jenkins/ && sudo chown jenkins:jenkins casc.yaml job-dsl.groovy)
sudo mkdir -p /var/lib/jenkins/init.groovy.d/
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d/
sudo mv /tmp/gitcred.groovy /var/lib/jenkins/init.groovy.d/gitcred.groovy
sudo mv /tmp/dockercred.groovy /var/lib/jenkins/init.groovy.d/dockercred.groovy


for plugin in /var/lib/jenkins/plugins/*.jpi; do
    plugin_name=$(basename -s .jpi "$plugin")
    sudo mkdir -p "/var/lib/jenkins/plugins/$plugin_name"
    echo "Extracting $plugin_name"
    sudo unzip -q "$plugin" -d "/var/lib/jenkins/plugins/$plugin_name"
done

sudo chown -R jenkins:jenkins /var/lib/jenkins/plugins/

echo "================================="
echo "Configuring Jenkins Service"
echo "================================="
echo 'CASC_JENKINS_CONFIG="/var/lib/jenkins/casc.yaml"' | sudo tee -a /etc/environment
echo 'JAVA_OPTS="-Djenkins.install.runSetupWizard=false"' | sudo tee -a /etc/environment
sudo sed -i 's/\(JAVA_OPTS=-Djava\.awt\.headless=true\)/\1 -Djenkins.install.runSetupWizard=false/' /lib/systemd/system/jenkins.service
sudo sed -i '/Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"/a Environment="CASC_JENKINS_CONFIG=/var/lib/jenkins/casc.yaml"' /lib/systemd/system/jenkins.service

# Reload systemd daemon and start Jenkins
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl status jenkins

# Installing Docker
echo "================================="
echo "Installing Docker"
echo "================================="
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Get Jenkins initial password
echo "================================="
echo "Getting Jenkins initial password"
echo "================================="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword