#!/bin/bash

# Rails is installed, generate credentials and keys
echo "Deleting old credentials file, if present..."
rm config/master.key
rm config/credentials.yml.enc
echo "Generating a new master key..."
bin/rails credentials:edit
echo "Generating a new secret_key_base..."
SECRET_KEY_BASE=$(bin/rails secret)
echo "Re-encrypting credentials with the new key..."
#echo "$SECRET_KEY_BASE" | bin/rails credentials:edit --force
EDITOR='echo "secret_key_base=$SECRET_KEY_BASE" >> ' bin/rails credentials:edit
