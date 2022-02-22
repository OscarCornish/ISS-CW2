## Script to sign EmployeeB2 csr, located at `/unsigned/EmployeeB2.csr`

mkdir signed

# Write to config
cat > "openssl.cnf" << EOF
[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
EOF

# Sign CSR using the above config for the alt_names
openssl x509 -req \
        -in "unsigned/EmployeeB2.csr" \
        -CA "x509/certs/nobsCA.crt" \
        -CAkey "x509/private/nobsCA.key" \
        -CAcreateserial -days 365 \
        -extensions v3_req \
        -extfile "openssl.cnf" \
        -out "signed/EmployeeB2.crt"
    

# Verify cert
openssl x509 -noout -text -in signed/EmployeeB2.crt

# Send back to EmployeeB2 machine
