/*
This example pipeline tests Vault authentication via CURL,
in the cases where the Vault Agent can't be installed onto the Jenkins host.
*/

pipeline {
agent any
    environment {
        VAULT_ADDR="${VAULT_ADDR}"
        ROLE_ID="c4cec819-eae2-ca98-b312-46fcfe322c7c"
        SECRET_ID=credentials("SECRET_ID")
        SECRETS_PATH="secrets/creds/dev"
    }

    stages {     
      stage('Stage 0') {
          steps {
            sh """
            export PATH=/usr/local/bin:${PATH}
            # AppRole Auth request
            curl --request POST \
              --data "{ \"role_id\": \"$ROLE_ID\", \"secret_id\": \"$SECRET_ID\" }" \
              ${VAULT_ADDR}/v1/auth/approle/login > login.json

            VAULT_TOKEN=$(cat login.json | jq -r .auth.client_token)
            # Secret read request
            curl  --header "X-Vault-Token: $VAULT_TOKEN" \
              ${VAULT_ADDR}/v1/${SECRETS_PATH} | jq .
            """
          }
      }
    }
}