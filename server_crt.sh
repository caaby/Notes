#! /bin/bash
 
if [ "$#" -ne 1 ]
then
  echo "Error: No domain name argument provided"
  echo "Usage: Provide a domain name as an argument"
  exit 1
fi
 
DOMAIN=$1
 
# Create root CA & Private key
openssl req -x509 -sha256 -days 356 -nodes -newkey rsa:2048 -subj "/CN=${DOMAIN}/C=US/L=San Fransisco" -keyout rootCA.key -out rootCA.crt 
 
# Generate Private key 
openssl genrsa -out server.key 2048
 
# Create csf conf
cat > csr.conf <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=US
ST=RandomState
L=RandomCity
O=RandomOrganization
OU=RandomOrganizationUnit
emailAddress=qlxge@qlx.com
CN = ${DOMAIN}
EOF
 
# create CSR request using private key
openssl req -new -key server.key -out server.csr -config csr.conf
 
# Create a external config file for the certificate
cat > cert.conf <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN}
DNS.2 = localhost
EOF
 
# Create SSl with self signed CA
openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -days 365 -sha256 -extfile cert.conf
