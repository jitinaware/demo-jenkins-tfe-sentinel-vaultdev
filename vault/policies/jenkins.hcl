path "secret/*" {
    capabilities = [ "read", "list" ]
  }


# Grant 'read' permission on the 'auth/approle/role/jenkins/role-id' path
path "auth/approle/role/jenkins/role-id" {
   capabilities = [ "read" , "list" ]
}

# Grant 'update' permission on the 'auth/approle/role/jenkins/secret-id' path
path "auth/approle/role/jenkins/secret-id" {
   capabilities = [ "read", "create", "update" ]
}

path "secret/data/mysql/webapp" {
  capabilities = [ "read" ]
}
