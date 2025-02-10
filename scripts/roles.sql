-- Criar papéis
CREATE ROLE admin LOGIN PASSWORD 'admin';
CREATE ROLE fornecedor LOGIN PASSWORD 'fornecedor';

-- Atribuir permissões aos papéis
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT SELECT, INSERT, UPDATE ON TABLE devices_type,device TO fornecedor;