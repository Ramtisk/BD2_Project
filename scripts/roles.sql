-- Criar papéis
CREATE ROLE admin LOGIN PASSWORD 'admin';
CREATE ROLE fornecedor LOGIN PASSWORD 'password123';
CREATE ROLE cliente LOGIN PASSWORD 'password123';

-- Atribuir permissões aos papéis
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT SELECT, INSERT, UPDATE ON TABLE vendas TO fornecedor;
GRANT SELECT ON TABLE produtos TO cliente;