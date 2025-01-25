CREATE OR REPLACE VIEW plan_devices AS
SELECT 
    pd.plan_id,
    p.name AS plan_name,
    d.device_id,
    d.serial_number,
    dt.name AS device_type_name
FROM plan_device pd
JOIN plan p ON pd.plan_id = p.plan_id
JOIN device d ON pd.device_id = d.device_id
JOIN devices_type dt ON d.device_type_id = dt.device_type_id;

CREATE OR REPLACE VIEW user_discounts AS
SELECT 
    u.id AS user_id, 
    u.username AS user_name, 
    CASE 
        WHEN COUNT(s.discount_id) FILTER (WHERE s.discount_id IS NOT NULL) > 0 THEN TRUE
        ELSE FALSE
    END AS has_discount
FROM auth_user u
LEFT JOIN subscription s ON u.id = s.user_id
GROUP BY u.id, u.username;

CREATE OR REPLACE VIEW clientes_recentes AS
SELECT *
FROM auth_user
where is_staff=false and is_superuser=false and is_active=true
ORDER BY date_joined DESC
LIMIT 10;

-- View p mostrar as visitas tecnicas (limit 10)
CREATE OR REPLACE VIEW visitas_tecnicas_por_vir AS
SELECT *
FROM tecnical_visit
WHERE date > CURRENT_TIMESTAMP
ORDER BY date ASC
LIMIT 10;