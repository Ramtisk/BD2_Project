#!/bin/bash
set -e

echo "Iniciando script de inicialização do MongoDB..."

mongosh <<EOF
use admin
db.createUser({
  user: "admin",
  pwd: "admin",
  roles: [
    { role: "root", db: "admin" },
    { role: "readWrite", db: "bd2_mongodb" }
  ]
});
print("Usuário criado com sucesso!");
EOF

echo "Script de inicialização do MongoDB concluído."
