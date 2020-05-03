# Dummy Certification Authority
A quick and dirty way for creating a Root Certification Authority (CA) and one Intermediate CA for testing.

## How-To
```
git clone https://github.com/kintoandar/dummy_ca.git
cd dummy_ca
./build.sh
```
Yep, that easy!

## Motivation
This tiny script was made to help me do a review of Hashicorp Vault PKI backend, you can [read all about it here](https://blog.kintoandar.com/2015/11/vault-PKI-made-easy.html).

## Credits
Reading [Jamie's Blog](https://jamielinux.com/docs/openssl-certificate-authority/) is a must!

Fork de [kintoandar](https://blog.kintoandar.com)

# Création des certificats

Dans le pem à coller dans nginx il faut mettre la chaine de certificat : site + intermediaire

L'ordre est signé par puis signataire puis signataire du signataire, le root ca n'est pas nécessaire.

1. site 
2. intermediaire
3. root CA

Il suffit d'installer l'autorité racine (root CA) dans le navigateur, une fois que qu'il est trust, aller sur un site qui present sa chaine "site + intermédiaire" suffit à être en règles