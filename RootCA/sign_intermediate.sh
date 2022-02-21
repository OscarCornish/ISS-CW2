## Script for signing the nobs CAs CSR (saved under nobsCA.csr)

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

# Sign the subordinate csr signed by root
openssl x509 -req \
	-CA x509/certs/RootCA_Cert.crt -CAkey x509/private/RootCA.key \
	-CAcreateserial -days 1825 -sha256 \
	-extfile "openssl.cnf" -extensions v3_req \
	-in nobsCA.csr -out nobsCA.crt

# Verify subordinate cert
openssl x509 -noout -text -in nobsCA.crt

# Verify against root cert
openssl verify -CAfile x509/certs/RootCA_Cert.crt nobsCA.crt

# Return cert to nobsCA
