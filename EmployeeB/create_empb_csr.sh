# Prep dirs
# Strong swan has specific dirs to use
mkdir -p etc/ipsec.d/private
mkdir etc/ipsec.d/certs
chmod 700 etc/ipsec.d/private

# Write to config
cat > "openssl.cnf" << EOF
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
C  = UK
ST = Coventry
L  = Coventry
O  = Nobs
CN = EmployeeB

[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
EOF

# Make CSR + key
openssl req \
        -newkey rsa:1024 -nodes -keyout etc/ipsec.d/private/EmployeeB.key \
        -subj "/C=UK/ST=Coventry/L=Coventry/O=Nobs/CN=EmployeeB" \
        -config "openssl.cnf" -extensions v3_req \
        -sha256 -out EmployeeB.csr

chmod 400 etc/ipsec.d/private/EmployeeB.key

# Send to subordinate CA for signing
