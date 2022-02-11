## Script to sign strongswan csr, located at `/unsigned/strongswan.csr`

mkdir unsigned signed

# Write to config (Important part here is the alt_names)
cat > "openssl.cnf" << EOF
[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
subjectAltName       = @alt_names

# Alternative names are specified as IP.# and DNS.# for IP addresses and
# DNS accordingly. 
[alt_names]
IP.1  = 213.1.133.98
DNS.1 = gw1.nobs.cyber.test
EOF

# Sign CSR using the above config for the alt_names
openssl x509 -req \
        -in "unsigned/strongswan.csr" \
        -CA "x509/certs/nobsCA.crt" \
        -CAkey "x509/private/nobsCA.key" \
        -CAcreateserial -days 365 \
        -extensions v3_req \
        -extfile "openssl.cnf" \
        -out "signed/strongswan.crt"
    

# Verify cert
openssl x509 -noout -text -in sgined/strongswan.crt

# Send back to strongswan machine