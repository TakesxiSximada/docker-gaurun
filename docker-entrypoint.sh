#! /bin/sh
set -e
vault auth $VAULT_TOKEN
mkdir -p /gaurun/cert
vault read -field value secret/gaurun.key > /gaurun/cert/gaurun.key
vault read -field value secret/gaurun.cert > /gaurun/cert/gaurun.cert
chmod 600 /gaurun/cert/gaurun.key /gaurun/cert/gaurun.cert
chown $NG_USER /gaurun/cert/gaurun.key /gaurun/cert/gaurun.cert
exec gosu $NG_USER gaurun -c gaurun.toml
