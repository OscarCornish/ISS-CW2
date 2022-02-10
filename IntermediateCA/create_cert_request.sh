## Create Intermediate CA certificate

# Prep dirs
mkdir -p x509/private
mkdir x509/certs
mkdir x509/unsigned
chmod 700 x509/private

# Create key + csr
openssl req \
		-newkey rsa:1024 -nodes -keyout x509/private/IntermediateCA.key \
		-subj "/C=UK/ST=Coventry/L=Coventry/O=Nobs Intermediate CA/CN=(Untrustworthy) Example Intermediate Certificate Authority" \
		-sha256 -days 3650 -out x509/unsigned/IntermediateCA_CertRequest.csr
# Set key to read only
chmod 400 x509/private/IntermediateCA.key

# Send CSR to RootCA
