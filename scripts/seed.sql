-- Removendo dados existentes das tabelas relacionadas para evitar conflitos
DELETE FROM auth_user_groups;
DELETE FROM auth_group_permissions;
DELETE FROM auth_user_user_permissions;
DELETE FROM auth_user;
DELETE FROM auth_group;
DELETE FROM auth_permission;
DELETE FROM Address;
DELETE FROM Device;
DELETE FROM Devices_Type;
DELETE FROM Discount;
DELETE FROM Plan;
DELETE FROM Subscription;
DELETE FROM Payment;
DELETE FROM Tecnical_Visit;
DELETE FROM Subcription_Visit;
DELETE FROM Plan_Device;
DELETE FROM Plan_Subscription;

-- Inserindo dados na tabela auth_user
INSERT INTO auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES
(2, 'pbkdf2_sha256$216000$wNlEIFL4aDXT$vcQsjNuqE+06PnoXDQ9IFDRjbnwdDheevkE+K6S8CDA=', NULL, FALSE, 'maria_oliveira', 'Maria', 'Oliveira', 'maria.oliveira@example.com', FALSE, TRUE, NOW()),
(3, 'pbkdf2_sha256$216000$wNlEIFL4aDXT$vcQsjNuqE+06PnoXDQ9IFDRjbnwdDheevkE+K6S8CDA=', NULL, FALSE, 'antonio_santos', 'António', 'Santos', 'antonio.santos@example.com', FALSE, TRUE, NOW()),
(4, 'pbkdf2_sha256$216000$wNlEIFL4aDXT$vcQsjNuqE+06PnoXDQ9IFDRjbnwdDheevkE+K6S8CDA=', NULL, FALSE, 'paulinho_andrade', 'Paulo', 'Andrade', 'pandrade@example.com', FALSE, TRUE, NOW()),
(5, 'pbkdf2_sha256$216000$wNlEIFL4aDXT$vcQsjNuqE+06PnoXDQ9IFDRjbnwdDheevkE+K6S8CDA=', NULL, TRUE, 'joao_silva', 'João', 'Silva', 'joao.silva@example.com', TRUE, TRUE, NOW());

-- Inserindo dados na tabela auth_group
INSERT INTO auth_group (id, name)
VALUES
(1, 'admin'),
(2, 'client'),
(3, 'fornecedor');

-- Inserindo dados na tabela auth_permission
INSERT INTO auth_permission (id, name, content_type_id, codename)
VALUES
(1, 'Pode adicionar utilizador', 1, 'add_user'),
(2, 'Pode alterar utilizador', 1, 'change_user'),
(3, 'Pode eliminar utilizador', 1, 'delete_user');

-- Inserindo dados na tabela auth_user_groups
INSERT INTO auth_user_groups (id, user_id, group_id)
VALUES
(1, 5, 1), -- João Silva como 'admin'
(2, 2, 2), -- Maria Oliveira como 'client'
(3, 3, 3); -- António Santos como 'fornecedor'

-- Inserindo dados na tabela auth_group_permissions
INSERT INTO auth_group_permissions (id, group_id, permission_id)
VALUES
(1, 1, 1), -- Permissão 'add_user' para 'admin'
(2, 2, 2), -- Permissão 'change_user' para 'client'
(3, 3, 3); -- Permissão 'delete_user' para 'fornecedor'

-- Inserindo dados na tabela Address
INSERT INTO Address (address_id, street, city, postal_code, country, user_id)
VALUES
(1, 'Rua das Flores, 123', 'Lisboa', '1000-123', 'Portugal', 2),
(2, 'Avenida da Liberdade, 456', 'Porto', '4000-456', 'Portugal', 3),
(3, 'Praça do Comércio, 789', 'Coimbra', '3000-789', 'Portugal', 4);

-- Inserindo dados na tabela Devices_Type
INSERT INTO Devices_Type (device_type_id, name, description, image)
VALUES
(1, 'Smartphone', 'Um dispositivo portátil que combina funções de telefone móvel e computação.', NULL),
(2, 'Router', 'Um dispositivo que encaminha pacotes de dados entre redes de computadores.', NULL),
(3, 'Televisão', 'Um dispositivo que recebe sinais de televisão e os reproduz numa tela.', NULL);

-- Inserindo dados na tabela Device
INSERT INTO Device (device_id, device_type_id, installation_date, serial_number)
VALUES
(1, 1, '2023-01-01 10:00:00', 'SN123456'),
(2, 2, '2023-02-01 11:00:00', 'SN789012'),
(3, 3, '2023-03-01 12:00:00', 'SN345678');

-- Inserindo dados na tabela Discount
INSERT INTO Discount (discount_id, name, percent, active)
VALUES
(1, 'Desconto de Ano Novo', 10, TRUE),
(2, 'Promoção de Verão', 20, TRUE),
(3, 'Black Friday', 30, TRUE);

-- Inserindo dados na tabela Plan
INSERT INTO Plan (plan_id, name, description, price, service_type)
VALUES
(1, 'Plano Básico', 'Plano de serviço básico', 29.99, 'Internet'),
(2, 'Plano Premium', 'Plano de serviço premium', 49.99, 'TV'),
(3, 'Plano Ultimate', 'Plano de serviço ultimate', 69.99, 'Telemovel');

-- Inserindo dados na tabela Subscription
INSERT INTO Subscription (subscription_id, user_id, discount_id, start_date, end_date)
VALUES
(1, 2, 1, '2023-01-01 00:00:00', '2024-01-01 00:00:00'),
(2, 3, 2, '2023-02-01 00:00:00', '2024-02-01 00:00:00'),
(3, 4, 3, '2023-03-01 00:00:00', '2024-03-01 00:00:00');

-- Inserindo dados na tabela Payment
INSERT INTO Payment (payment_id, subscription_id, user_id, amount, date, entity, refence)
VALUES
(1, 1, 2, 29.99, '2023-01-01 10:00:00', 'Banco', 'REF123'),
(2, 2, 3, 49.99, '2023-02-01 11:00:00', 'Banco', 'REF456'),
(3, 3, 4, 69.99, '2023-03-01 12:00:00', 'Banco', 'REF789');

-- Inserindo dados na tabela Tecnical_Visit
INSERT INTO Tecnical_Visit (tecnical_visit_id, tecnical_id, device_id, note, date)
VALUES
(1, 2, 1, 'Instalação concluída com sucesso.', '2023-01-01 10:00:00'),
(2, 3, 2, 'Manutenção do dispositivo realizada.', '2023-02-01 11:00:00'),
(3, 4, 3, 'Inspeção do dispositivo concluída.', '2023-03-01 12:00:00');

-- Inserindo dados na tabela Subcription_Visit
INSERT INTO Subcription_Visit (subcription_visit_id, subscription_id, tecnical_visit_id)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

-- Inserindo dados na tabela Plan_Device
INSERT INTO Plan_Device (plan_device_id, plan_id, device_id)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

-- Inserindo dados na tabela Plan_Subscription
INSERT INTO Plan_Subscription (plan_subscription_id, plan_id, subscription_id)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);
