# Creating the x509 certificate hierarchy

## Structure:

---

```
                                                        ┌─────────┐
                                                        │         │
                                           ┌────────────┤ Devices │
                ┌─────────┐                │            │         │
                │         │                │            └─────────┘
                │ Root CA │◄───────────────┘
                │         │        Trusts
                └────┬────┘
                     │
                     │   Signs
        Public       │
       ─ ─ ─ ─ ─ ─ ─ ├─ ─ ─ ─ ─ ─ ─
        Private      │
                     │
                     │
                     │
                     ▼
             ┌────────────────┐
             │                │
        ┌────┤ Subordinate CA ├───┐
        │    │                │   │
  Signs │    └────────────────┘   │   Signs
        │                         │
        │                         │
        ▼                         ▼
┌────────────────┐        ┌──────────┐
│                │        │          │
│ Webserver Cert │        │ VPN Cert │
│                │        │          │
└────────────────┘        └──────────┘
```
The benefits to using a subordinate CA is that the organisation can issue and revoke new certificates quickly and easily, they do not rely on the 

## Creating the certificates:

---

### Root CA: (`RootCA/cert_script.sh`)

This script creates a simple directory structure, then creates the private key and cert.

> Here we have the private key in a directory that has access limited to our user, however in a real world implementation the private key would not be stored offline.

we generate the certificate with numerous flags:

- *-newkey rsa:1024* : Create a new key for this certificate (1024 bits is low for a root CA, this is for demonstration only)
- *-nodes* : Do not encrypt the output key (again, just for simplification)
- *-x509* : output x509 certificate
- *-days 3650* : Certificate is valid for 10 years (almost...)

Then make the key read only (to our user) since we dont intend on changing the file.

Then just verify that the key is valid.

```sh
## Create and verify root certificates

# Prep directories
mkdir -p x509/private
mkdir -p x509/certs
chmod 700 x509/private

# Create cert + key
openssl req \
	-newkey rsa:1024 -nodes -keyout x509/private/RootCA.key \
	-subj "/C=UK/ST=Coventry/L=Coventry/O=Nobs Root CA/CN=(Untrustworthy) Example Certificate Authority" \
	-sha256 -x509 -days 3650 -out x509/certs/RootCA_Cert.crt

# Make key read only
chmod 400 x509/private/RootCA.key

# Verify key
openssl x509 -noout -text -in x509/certs/RootCA_Cert.crt
```
---
### Subordinate Certificate Request: (`NobsCA/create_csr.sh`)

Works in the same way as the previous example, except this time dropping the *-x509* tag, since we would like a certificate request instead of a self-signed certificate.

```sh
## Create a certificate request for the NOBS subordinate CA

# Prep dirs
mkdir -p x509/private
mkdir x509/certs
mkdir x509/unsigned

chmod 700 x509/private

# Create certificate signing request + key
openssl req \
        -newkey rsa:1024 -nodes -keyout x509/private/nobsCA.key \
        -subj "/C=UK/ST=Coventry/L=Coventry/O=Nobs Subordinate CA/CN=Nobs CA" \
        -sha256 -days 1825 -out x509/unsigned/nobsCA.csr

# Make key read only
chmod 400 x509/private/nobsCA.key
```
---
### Signing the Subordinate Certificate Request: (`RootCA/sign_intermediate.sh`)

> Prior to running this script the `NobsCA.csr` on the IntermediateCA machine should be transfered to the `RootCA/x509/NobsCA.csr`

Here we see some new flags:
- *-CAcreateserial* : Creates a serial number file if one doesn't already exist (this is used to keep track of which certificates have been issued and to who).
- *-days 1825* : Approx 5 years, could be anything but certificate will be      invalidated when the root expires.

```sh
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
```
Now the certificate (`NobsCA.crt`) can be returned to the IntermediateCA machine for use.
