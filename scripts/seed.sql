-- Removendo dados existentes das tabelas relacionadas para evitar conflitos
DELETE FROM auth_user_groups;
DELETE FROM auth_group_permissions;

-- Reinserindo os grupos com os novos valores
DELETE FROM auth_group;
INSERT INTO auth_group (name)
VALUES
('admin'),
('client');

-- Ajustando as associações de usuários aos novos grupos
INSERT INTO auth_user_groups (user_id, group_id)
VALUES
(2, 1), -- João Silva como 'admin'
(3, 2); -- Maria Oliveira como 'client'

-- Ajustando permissões para os novos grupos
INSERT INTO auth_group_permissions (group_id, permission_id)
VALUES
(1, 1), -- Permissão 'add_user' para 'admin'
(2, 2); -- Permissão 'change_user' para 'client'

-- Inserindo dados na tabela auth_user
INSERT INTO auth_user (password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES
('password1', NULL, TRUE, 'joao_silva', 'João', 'Silva', 'joao.silva@example.com', TRUE, TRUE, NOW()),
('password2', NULL, FALSE, 'maria_oliveira', 'Maria', 'Oliveira', 'maria.oliveira@example.com', FALSE, TRUE, NOW()),
('password3', NULL, FALSE, 'antonio_santos', 'António', 'Santos', 'antonio.santos@example.com', FALSE, TRUE, NOW());

-- Inserindo dados na tabela auth_permission
INSERT INTO auth_permission (name, content_type_id, codename)
VALUES
('Pode adicionar utilizador', 1, 'add_user'),
('Pode alterar utilizador', 1, 'change_user'),
('Pode eliminar utilizador', 1, 'delete_user');

-- Inserindo dados na tabela Address
INSERT INTO address (street, city, postal_code, country, user_id)
VALUES
('Rua das Flores, 123', 'Lisboa', '1000-123', 'Portugal', 2),
('Avenida da Liberdade, 456', 'Porto', '4000-456', 'Portugal', 3),
('Praça do Comércio, 789', 'Coimbra', '3000-789', 'Portugal', 4);

-- Inserindo dados na tabela DevicesType
INSERT INTO devices_type (name, description, image)
VALUES
('Smartphone', 'Um dispositivo portátil que combina funções de telefone móvel e computação.', NULL),
('Router', 'Um dispositivo que encaminha pacotes de dados entre redes de computadores.', NULL),
('Televisão', 'Um dispositivo que recebe sinais de televisão e os reproduz numa tela.', NULL);

-- Inserindo dados na tabela Device
INSERT INTO device (device_type_id, installation_date, serial_number)
VALUES
(1, '2023-01-01 10:00:00', 'SN123456'),
(2, '2023-02-01 11:00:00', 'SN789012'),
(3, '2023-03-01 12:00:00', 'SN345678');

-- Inserindo dados na tabela Discount
INSERT INTO discount (name, percent, active)
VALUES
('Desconto de Ano Novo', 10, TRUE),
('Promoção de Verão', 20, TRUE),
('Black Friday', 30, TRUE);

-- Inserindo dados na tabela Plan
INSERT INTO plan (name, description, price, service_type)
VALUES
('Plano Básico', 'Plano de serviço básico', 29.99, 'Internet'),
('Plano Premium', 'Plano de serviço premium', 49.99, 'TV'),
('Plano Ultimate', 'Plano de serviço ultimate', 69.99, 'Telemóvel');

-- Inserindo dados na tabela Subscription
INSERT INTO subscription (user_id, discount_id, start_date, end_date)
VALUES
(2, 1, '2023-01-01 00:00:00', '2024-01-01 00:00:00'),
(3, 2, '2023-02-01 00:00:00', '2024-02-01 00:00:00'),
(4, 3, '2023-03-01 00:00:00', '2024-03-01 00:00:00');

-- Inserindo dados na tabela Payment
INSERT INTO payment (subscription_id, user_id, amount, date, entity, refence)
VALUES
(1, 2, 29.99, '2023-01-01 10:00:00', 'Banco', 'REF123'),
(2, 3, 49.99, '2023-02-01 11:00:00', 'Banco', 'REF456'),
(3, 4, 69.99, '2023-03-01 12:00:00', 'Banco', 'REF789');

-- Inserindo dados na tabela TecnicalVisit
INSERT INTO tecnical_visit (tecnical_id, device_id, note, date)
VALUES
(2, 1, 'Instalação concluída com sucesso.', '2023-01-01 10:00:00'),
(3, 2, 'Manutenção do dispositivo realizada.', '2023-02-01 11:00:00'),
(4, 3, 'Inspeção do dispositivo concluída.', '2023-03-01 12:00:00');

-- Inserindo dados na tabela SubcriptionVisit
INSERT INTO subcription_visit (subscription_id, tecnical_visit_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserindo dados na tabela PlanDevice
INSERT INTO plan_device (plan_id, device_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserindo dados na tabela PlanSubscription
INSERT INTO plan_subscription (plan_id, subscription_id)
VALUES
(1, 1),
(2, 2),
(3, 3);


/*
-- Inserindo dados na tabela auth_user
INSERT INTO auth_user (password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES
('password1', NULL, TRUE, 'joao_silva', 'João', 'Silva', 'joao.silva@example.com', TRUE, TRUE, NOW()),
('password2', NULL, FALSE, 'maria_oliveira', 'Maria', 'Oliveira', 'maria.oliveira@example.com', FALSE, TRUE, NOW()),
('password3', NULL, FALSE, 'antonio_santos', 'António', 'Santos', 'antonio.santos@example.com', FALSE, TRUE, NOW());

-- Inserindo dados na tabela auth_group
INSERT INTO auth_group (name)
VALUES
('Grupo1'),
('Grupo2'),
('Grupo3');

-- Inserindo dados na tabela auth_permission
INSERT INTO auth_permission (name, content_type_id, codename)
VALUES
('Pode adicionar utilizador', 1, 'add_user'),
('Pode alterar utilizador', 1, 'change_user'),
('Pode eliminar utilizador', 1, 'delete_user');

-- Inserindo dados na tabela auth_user_groups
INSERT INTO auth_user_groups (user_id, group_id)
VALUES
(2, 1),
(3, 2),
(4, 3);

-- Inserindo dados na tabela auth_user_user_permissions
INSERT INTO auth_user_user_permissions (user_id, permission_id)
VALUES
(2, 1),
(3, 2),
(4, 3);

-- Inserindo dados na tabela auth_group_permissions
INSERT INTO auth_group_permissions (group_id, permission_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserindo dados na tabela Address
INSERT INTO address (street, city, postal_code, country, user_id)
VALUES
('Rua das Flores, 123', 'Lisboa', '1000-123', 'Portugal', 2),
('Avenida da Liberdade, 456', 'Porto', '4000-456', 'Portugal', 3),
('Praça do Comércio, 789', 'Coimbra', '3000-789', 'Portugal', 4);

-- Inserindo dados na tabela DevicesType
INSERT INTO devices_type (name, description, image)
VALUES
('Smartphone', 'Um dispositivo portátil que combina funções de telefone móvel e computação.', NULL),
('Router', 'Um dispositivo que encaminha pacotes de dados entre redes de computadores.', NULL),
('Televisão', 'Um dispositivo que recebe sinais de televisão e os reproduz numa tela.', NULL);

-- Inserindo dados na tabela Device
INSERT INTO device (device_type_id, installation_date, serial_number)
VALUES
(1, '2023-01-01 10:00:00', 'SN123456'),
(2, '2023-02-01 11:00:00', 'SN789012'),
(3, '2023-03-01 12:00:00', 'SN345678');

-- Inserindo dados na tabela Discount
INSERT INTO discount (name, percent, active)
VALUES
('Desconto de Ano Novo', 10, TRUE),
('Promoção de Verão', 20, TRUE),
('Black Friday', 30, TRUE);

-- Inserindo dados na tabela Plan
INSERT INTO plan (name, description, price, service_type)
VALUES
('Plano Básico', 'Plano de serviço básico', 29.99, 'Internet'),
('Plano Premium', 'Plano de serviço premium', 49.99, 'TV'),
('Plano Ultimate', 'Plano de serviço ultimate', 69.99, 'Telemóvel');

-- Inserindo dados na tabela Subscription
INSERT INTO subscription (user_id, discount_id, start_date, end_date)
VALUES
(2, 1, '2023-01-01 00:00:00', '2024-01-01 00:00:00'),
(3, 2, '2023-02-01 00:00:00', '2024-02-01 00:00:00'),
(4, 3, '2023-03-01 00:00:00', '2024-03-01 00:00:00');

-- Inserindo dados na tabela Payment
INSERT INTO payment (subscription_id, user_id, amount, date, entity, refence)
VALUES
(1, 2, 29.99, '2023-01-01 10:00:00', 'Banco', 'REF123'),
(2, 3, 49.99, '2023-02-01 11:00:00', 'Banco', 'REF456'),
(3, 4, 69.99, '2023-03-01 12:00:00', 'Banco', 'REF789');

-- Inserindo dados na tabela TecnicalVisit
INSERT INTO tecnical_visit (tecnical_id, device_id, note, date)
VALUES
(2, 1, 'Instalação concluída com sucesso.', '2023-01-01 10:00:00'),
(3, 2, 'Manutenção do dispositivo realizada.', '2023-02-01 11:00:00'),
(4, 3, 'Inspeção do dispositivo concluída.', '2023-03-01 12:00:00');

-- Inserindo dados na tabela SubcriptionVisit
INSERT INTO subcription_visit (subscription_id, tecnical_visit_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserindo dados na tabela PlanDevice
INSERT INTO plan_device (plan_id, device_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserindo dados na tabela PlanSubscription
INSERT INTO plan_subscription (plan_id, subscription_id)
VALUES
(1, 1),
(2, 2),
(3, 3);*/