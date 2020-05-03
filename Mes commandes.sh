# https://www.sslshopper.com/article-most-common-openssl-commands.html

printf "\n==> Generating Root CA key:\n"
openssl genrsa -aes256 -out rootca.key 4096
# pass:rootca

printf "\n==> Génère un CA.crt autosigné (-x509 + -days):\n"
openssl req -config root.cnf -key rootca.key \
  -new -x509 -days 3650 -extensions v3_ca -out rootca.pem

# avoir un aperçu du certificat généré
openssl x509 -in rootca.pem -text -noout

printf "\n==> Generating Intermediate CA key:\n"
# clé rsa du certif intermédiaire
openssl genrsa -aes256 -out intermediateca.key 4096
#passwd:intca

printf "\n==> Génère la demande de certificat du CA intermédiaire:\n"
openssl req -config intermediate.cnf -new \
  -key intermediateca.key \
  -out intermediateca.csr

# aperçu
openssl req -text -noout -verify -in intermediateca.csr

printf "\n==> Requesting Intermediate CA certificate to the Root CA:\n"
openssl ca -config $ROOT_CA/openssl.cnf -extensions v3_intermediate_ca -days 1825 \
  -notext -md sha256 -in $INTERMEDIATE_CA/csr/intermediate.csr \
  -out $INTERMEDIATE_CA/certs/intermediate.pem


