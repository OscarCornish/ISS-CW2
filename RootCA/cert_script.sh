## Create and verify root certificates

# Prep directories
mkdir -p x509/private
mkdir -p x509/certs
chmod 700 x509/private

# Write to config
cat > "openssl.cnf" << EOF
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
C  = UK

[v3_req]
basicConstraints     = critical, CA:TRUE
subjectKeyIdentifier = hash
keyUsage             = critical, digitalSignature, cRLSign, keyCertSign
EOF

# Create cert + key
openssl req \
	-newkey rsa:1024 -nodes -keyout x509/private/RootCA.key \
	-subj "/C=UK/ST=Coventry/L=Coventry/O=Nobs Root CA/CN=(Untrustworthy) Example Certificate Authority" \
    -extensions v3_req \
	-sha256 -x509 -days 3650 -config "openssl.cnf" -out x509/certs/RootCA_Cert.crt

# Make key read only
chmod 400 x509/private/RootCA.key

# Verify key
openssl x509 -noout -text -in x509/certs/RootCA_Cert.crt

