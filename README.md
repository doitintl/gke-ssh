
# Goal
Deploy an SSH bastion host based on an tweaked Helm chart [1] within a private GKE cluster to prove that can be publicly accessible via NLB and controllable via ACL.

This solution deploys all the infrastructure needed from scratch, from the Google project, the networking, the GKE up to the K8S deployment via Helm.

**IMPORTANT:** once destroyed, and in case you want to deploy it again, you'll need to set a new project name in `config.env` since it stays pending for deletion for 30 days so that Google can bill on the usage. [2]

<br />

# Requirements
1. Software: gmake, docker.
2. GCP permissions to create new projects. [3]

This has been developed and tested using Cloud Shell. Since it is Docker based it can run anywhere. All the pakages and modules versions are hardcoded to make sure that the outcome is consistent. 

<br />

# Usage instructions
1. Create a Google Storage bucket where to keep Terraform's state.
```
gsutil mb gs://<BUCKET_NAME>
```
2. Edit the configuration files:
    * `config.env` (mandatory): you must set the bucket you just created in the previous state, the project to be created, the billing id associated and the user name and private SSH key. Create this file by copying the file `config.env.tmpl`
    * `variables.tf` (optional): by default it is deployed in europe-west4 but you can change this and other configuration parameters here.
3. Execute the following commands. 
```
# Builds and runs the Docker image
make all
# Returns Terraform's plan useful to check what is going to be deployed
make plan
# Deploys the resources via Terraform
make deploy
# Destroys the resources via Terraform
make destroy
```
**IMPORTANT:** every time you change `config.env` you must execute `make all` in order to reload the variables. 

<br />

# Pending

- [ ] Add testing (terratest or builtin test).
- [ ] Add post-exec to show the NLB endpoint.

<br />

# References
[1] https://artifacthub.io/packages/helm/t3n/ssh-bastion

[2] https://cloud.google.com/resource-manager/docs/creating-managing-projects#shutting_down_projects

[3] https://cloud.google.com/resource-manager/docs/creating-managing-projects