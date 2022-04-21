#!/usr/bin/dumb-init /bin/sh

nohup `vault server -dev` &
sleep 5

# Grab the TF token
ROOT_TF_TOKEN=$(cat /tmp/shared/vault | sed -n -e 's/^.*ROOT_TF_TOKEN=//p') 

vault auth enable userpass

# Apply policies
vault policy write admin $POLICIESDIR/admin.hcl
vault policy write apps $POLICIESDIR/apps.hcl
vault policy write jenkins $POLICIESDIR/jenkins.hcl

vault write auth/userpass/users/admin password=$password policies=admin

sleep 5

vault secrets enable terraform
vault write terraform/config "token=$ROOT_TF_TOKEN"

USER_ID=$(curl -s \
    --header 'Authorization: Bearer '"$ROOT_TF_TOKEN" \
    --header 'Content-Type: application/vnd.api+json' \
    --request GET \
    https://app.terraform.io/api/v2/account/details | jq -r ".data.id")


vault write terraform/role/jenkins user_id=$USER_ID ttl=10m


# Enable approle on vault
vault auth enable approle

# one of 2 ways of doing this:
#vault write auth/approle/role/jenkins token_policies="jenkins","apps" \
# token_ttl=10m token_max_ttl=10m

# This method lets you control the maximum
# number of times the token can be used
vault write auth/approle/role/jenkins \
    secret_id_ttl=5m \
    token_num_uses=2 \
    token_ttl=10m \
    token_policies="jenkins","apps" \
    token_max_ttl=5m \
    secret_id_num_uses=1 
    

#vault secrets enable -path="secret" kv

# Seed a demo credential
vault kv put secret/mysql/webapp db_name="users" username="admin" password="passw0rd"

#ROLE_ID=$(vault read -format=json auth/approle/role/jenkins/role-id | jq -r ".data.role_id")
#sed -i -e "s/^VAULT_ROLE_ID.*/VAULT_ROLE_ID=$ROLE_ID/g" /tmp/shared/jenkins

#SECRET_ID=$(vault write -format=json -f auth/approle/role/jenkins/secret-id | jq -r ".data.secret_id")
#sed -i -e "s/^VAULT_SECRET_ID.*/VAULT_SECRET_ID=$SECRET_ID/g" /tmp/shared/jenkins

JENKINS_TOKEN=$(vault token create -field=token -policy=jenkins -ttl=10m -period=10m)
sed -i -e "s/^JENKINS_TOKEN.*/JENKINS_TOKEN=$JENKINS_TOKEN/g" /tmp/shared/jenkins

tail -f /dev/null