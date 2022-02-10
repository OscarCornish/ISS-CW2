## Script for signing the nobs CAs CSR (saved under nobsCA.csr)

# Sign the subordinate csr signed by root
openssl x509 -req \
	-CA x509/certs/RootCA_Cert.crt -CAkey x509/private/RootCA.key \
	-CAcreateserial -days 1825 -sha256 \
	-in x509/nobsCA.csr -out nobsCA.crt

# Verify subordinate cert
openssl x509 -noout -text -in nobsCA.crt

# Verify against root cert
openssl verify -CAfile x509/certs/RootCA_Cert.crt nobsCA.crt

# Return cert to nobsCA
