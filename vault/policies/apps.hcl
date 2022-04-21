# Get credentials from the terraform secrets engine
path "terraform/creds/jenkins" {
  capabilities = [ "read" ]
}
