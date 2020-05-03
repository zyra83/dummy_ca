cat << EOF > monsite.dev.lan.cnf
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = v3_req
prompt = no
default_md = sha256

[ req_distinguished_name ]
countryName                = FR
stateOrProvinceName        = Landes
localityName               = Geloux
organizationName           = Flash Corp.
OU                         = Formation
commonName                 = monsite.dev.lan

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[ alt_names ]
IP.1    = 127.0.0.1
DNS.1   = monsite
DNS.2   = monsite.dev.lan
DNS.3   = *.monsite.dev.lan
DNS.4   = localhost

EOF

# clé privée du serveur
openssl genrsa -out "monsite.dev.lan.key" 2048
chmod 400 "monsite.dev.lan.key"

# Demande de signature (csr) à transmettre à l'autorité de certification
openssl req -new -key "monsite.dev.lan.key" -out "monsite.dev.lan.csr" -config monsite.dev.lan.cnf
# affichage du CSR pour voir si il est OK
openssl req -text -noout -verify -in monsite.dev.lan.csr

# signature du CSR par le CA intermédiaire
openssl ca -config "pki/intermediate/openssl.cnf" -extensions server_cert -days 365 \
  -notext -md sha256 -in "monsite.dev.lan.csr" \
  -out "monsite.dev.lan.pem"

# concaténation du certificat du site et des certificats des CA intermediaire et ROOT (pour nginx).
cat monsite.dev.lan.pem  pki/intermediate/certs/chain.pem > dummy-website/ssl/chaine.pem
mv  monsite.dev.lan.key dummy-website/ssl/monsite.dev.lan.key
cp pki/root/certs/root.pem dummy-website/www/flash-corp-root-ca.crt

# ménage
rm -f "monsite.dev.lan.csr" "monsite.dev.lan.cnf" "monsite.dev.lan.pem"