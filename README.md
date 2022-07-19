## What is the image for?
The intended purpose of this image is for it to be used as a Jenkins agent. By using the installed features the user is able to create Jenkins pipelines that can trigger Terraform scripts to deploy and update infrastructure. Additionally, Terragrunt gives the ability to use extra tools for Terraform. An example of using this image as a Jenkins agent via [Kubernetes](https://plugins.jenkins.io/kubernetes/) can be seen below. 

First, an example of configuring the pod template in yaml to create the agent.

```yaml
jenkins:
  clouds:
    - kubernetes:
        name: "kubernetes"
        templates:
          - name: "image-builder-terraform"
            label: "image-builder-terraform"
            nodeUsageMode: NORMAL
            containers:
              - name: "image-terraform"
                image: "ghcr.io/liatrio/image-builder-terraform:${builder_images_version}"
```
And then specifying the agent in the Jenkinsfile for an example step.

```jenkins
stage('Build') {
  agent {
    label "image-builder-terraform"
  }
  steps {
    container('image-terraform') {
      sh "terragrunt plan"
      sh "terragrunt apply"
    }
  }
}
```

## What is installed on this image?
- Version [1.18](https://dl.google.com/go/go1.18.src.tar.gz) of the Go programming language
- Version [1.2.5](https://releases.hashicorp.com/terraform/1.2.1/) of infrastructure as code tool Terraform
- Version [0.38.4](https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.4/terragrunt_linux_amd64) of Terraform wrapper Terragrunt 

# Build
This repository contains a workflow that creates a current release tag and then uses the [build-scan-push](https://github.com/liatrio/github-workflows/blob/main/.github/workflows/build-scan-push.yaml) reusable workflow to build the docker image, run a Trivy vulnerability scan, and then push to GHCR. Below is an example 
