## Create a certificate request for the NOBS subordinate CA

# Prep dirs
mkdir -p x509/private
mkdir x509/certs
mkdir x509/unsigned

chmod 700 x509/private

cat > "openssl.cnf" << EOF
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
C  = UK

[ v3_req ]
basicConstraints        = critical, CA:TRUE, pathlen:1
subjectKeyIdentifier    = hash
keyUsage                = critical, cRLSign, digitalSignature, keyCertSign
EOF

# Create certificate signing request + key
openssl req \
        -newkey rsa:1024 -nodes -keyout x509/private/nobsCA.key \
        -subj "/C=UK/ST=Coventry/L=Coventry/O=Nobs/CN=Nobs Subordinate CA" \
        -config "openssl.cnf" -extensions v3_req \
        -sha256 -out x509/unsigned/nobsCA.csr

# Make key read only
chmod 400 x509/private/nobsCA.key


