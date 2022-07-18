# Overview
This repository contains a workflow that creates a current release tag and then uses the [build-scan-push](https://github.com/liatrio/github-workflows/blob/main/.github/workflows/build-scan-push.yaml) reusable workflow to build the docker image, run a Trivy vulnerability scan, and then push to GHCR.

## What is installed on this image?
- Version [1.18](https://dl.google.com/go/go1.18.src.tar.gz) of the Go programming language
- Version [1.2.1](https://releases.hashicorp.com/terraform/1.2.1/) of infrastructure as code tool Terraform
- Version [0.38.4](https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.4/terragrunt_linux_amd64) of Terraform wrapper Terragrunt 

## What is the image for?
The intended purpose of this image is for it to be used as a Jenkins agent. By using the installed features the user is able to create Jenkins pipelines that can trigger Terraform scripts to deploy and update infrastructure. Additionally, Terragrunt gives the ability to use extra tools for Terraform.

## What is required to run this workflow?
For this workflow to run, the only thing that needs to be input is a user or organizations `GITHUB_TOKEN`, which is automatically provided by GitHub Actions.
