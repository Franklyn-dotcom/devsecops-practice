#!/bin/bash

sudo chown -R $USER /var/lib/jenkins/workspace/devsecops-numeric-app/trivy
sudo chown -aG docker $USER
sudo chown -aG jenkins $USER
