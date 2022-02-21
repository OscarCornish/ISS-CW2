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
CN = Nobs Strongswan

[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
subjectAltName       = @alt_names

[alt_names]
IP.1  = 213.1.133.98
DNS.1 = gw1.nobs.cyber.test
EOF

# Make CSR + key
openssl req \
        -newkey rsa:1024 -nodes -keyout etc/ipsec.d/private/strongswan.key \
        -subj "/C=UK/ST=Coventry/L=Coventry/O=Nobs/CN=Nobs Strongswan" \
        -config "openssl.cnf" -extensions v3_req \
        -sha256 -out strongswan.csr

chmod 400 etc/ipsec.d/private/strongswan.key

# Send to subordinate CA for signing
