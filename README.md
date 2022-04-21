# Terraform Cloud/Enterprise + Sentinel + Jenkins + Vault Demo

This project unifies several HashiCorp & industry standard tools to address common use cases, including:

- Automated Infrastructure Deployment w/ Terraform & Jenkins Pipeline
- Dynamic Credentials via Vault
- Sentinel Policy Enforcement
- VCS Integration
- Cloud Cost Controls

We will be using Vault to not only store our sensitive credentials, but also generate short-lived credentials that serve a single purpose and expire after use. With this workflow we no longer need to hardcode credentials within our code, and can securely deploy infrastructure by 'shifting security left'.

This demo can be run in Terraform Cloud (Team & Governance, Business editions) as well as Terraform Enterprise (self-hosted). 

## Requirements

* A TFC/E account & organization. Sign up for a free trial of TFC [here](https://app.terraform.io/signup/account)
* AWS credentials to provision resources
* TFC/E API [user token](https://www.terraform.io/cloud-docs/users-teams-organizations/users#api-tokens)
* Local installation of Docker or Docker Desktop (MacOS)

## Configuration

1. Follow & complete the configuration steps from the [companion repository](https://github.com/EchelonProject/demo-tfe-sentinel-aws), then continue here
1. Clone this repository locally via ``` git clone ```
1. [Generate a TFC/E API User Token](https://www.terraform.io/cloud-docs/users-teams-organizations/users#api-tokens)  and paste it into the ```shared/vault``` file
    * NOTE: This is for demo purposesonly--in production you'd manually add it to Vault
1. Optionally change any other variables such as login username/password for Jenkins
    * Vault is being run in 'dev' mode so you can simply login with the ```root``` token
1. Launch the demo via ```./start build``` in the root directory of this repo
    * To destroy the environment, simply use ```./start destroy```

### Configure Jenkins Pipeline

After about 1-2 minutes, both Vault & Jenkins will be available for use.

1. Log into Jenkins via the default credentials (unless modified):
    * Username: ```jenkinsuser``` 
    * Password: ```changeme```
    * URL: ```http://localhost:8080```
1. Click <b>New Item</b> via the menu on the left
1. Enter an item name, such as ```Demo Pipeline```
1. Select <b>Pipeline</b> and click OK
1. On the next screen, click the Pipeline tab
1. Copy the contents of the Jenkins file at ```jenkins/Jenkinsfile``` & paste into the <b>Script</b> text area
1. Click <b>Save</b>


You can now click <b>Build Now</b> from the menu on the left. If everything was configured correctly, Jenkins should be able to process all of the stages until it gets to <b>TF Plan & Sentinel Policy Checks</b>, at which point it will fail due to policy failures.