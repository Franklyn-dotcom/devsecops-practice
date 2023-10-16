#!/bin/bash

set -eo pipefail

JENKINS_URL='http://74.220.28.164:8080'  # Updated Jenkins URL with the provided IP address

# You may need to update the credentials as well.
# Replace 'admin:admin' with your Jenkins username and password.
JENKINS_CRUMB=$(curl -s --cookie-jar /tmp/cookies -u admin:admin "${JENKINS_URL}/crumbIssuer/api/json" | jq -r '.crumb')

JENKINS_TOKEN=$(curl -s -X POST -H "Jenkins-Crumb:${JENKINS_CRUMB}" --cookie /tmp/cookies "${JENKINS_URL}/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken?newTokenName=demo-token66" -u admin:admin | jq -r '.data.tokenValue')

echo $JENKINS_URL
echo $JENKINS_CRUMB
echo $JENKINS_TOKEN

while read plugin; do
   echo "........Installing ${plugin} .."
   curl -s -X POST --data "<jenkins><install plugin='${plugin}' /></jenkins>" -H 'Content-Type: text/xml' "${JENKINS_URL}/pluginManager/installNecessaryPlugins" --user "admin:$JENKINS_TOKEN"
done < plugins.txt

# Additional comments and checks are not modified, so they remain as is.
