-- Função ajustada para calcular preços de planos ativos

CREATE OR REPLACE FUNCTION calculate_active_plan_prices()
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT SUM(p.price)
        FROM plan p
        JOIN plan_subscription ps ON p.plan_id = ps.plan_id
        JOIN subscription s ON ps.subscription_id = s.subscription_id
        WHERE s.end_date > NOW()
    );
END;
$$ LANGUAGE plpgsql;

---Aplicação de desconto no preço final:

CREATE OR REPLACE FUNCTION apply_final_discount(payment_id INT, discount_percent NUMERIC)
RETURNS VOID AS $$
BEGIN
    UPDATE PAYMENT SET AMOUNT = AMOUNT * ((100 - discount_percent) / 100)
    WHERE PAYMENT_ID = payment_id;
END;
$$ LANGUAGE plpgsql;

---Cálculo do lucro da empresa no mês:

CREATE OR REPLACE FUNCTION calculate_monthly_profit(month INT, year INT)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (SELECT SUM(AMOUNT) FROM PAYMENT WHERE EXTRACT(MONTH FROM DATE) = month AND EXTRACT(YEAR FROM DATE) = year);
END;
$$ LANGUAGE plpgsql;


-- Cálculo do total ganho
CREATE OR REPLACE FUNCTION calculate_total_profit()
RETURNS FLOAT AS $$
DECLARE
    total_profit FLOAT := 0; -- Inicializar a variável com 0
BEGIN
    -- Calcular o lucro total somando todos os pagamentos na tabela Payment
    SELECT TRUNC(SUM(amount) * 100) / 100
    INTO total_profit
    FROM Payment;

    -- Tratar o caso em que SUM retorna NULL
    IF total_profit IS NULL THEN
        total_profit := 0;
    END IF;

    -- Retornar o lucro total com 2 casas decimais
    RETURN total_profit;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_clientes()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM auth_user where is_staff=false and is_superuser=false and is_active=true);
END;
$$ LANGUAGE plpgsql;

-- Função para buscar planos associados a um username
CREATE OR REPLACE FUNCTION get_user_planos(username_input VARCHAR)
RETURNS TABLE (
    plan_id INTEGER,
    plan_name TEXT,
    plan_description TEXT,
    price FLOAT,
    service_type VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.plan_id,
        p.name AS plan_name,
        p.description AS plan_description,
        p.price,
        p.service_type
    FROM 
        auth_user u
    JOIN 
        Subscription s ON u.id = s.user_id
    JOIN 
        plan_subscription ps ON s.subscription_id = ps.subscription_id
    JOIN 
        Plan p ON ps.plan_id = p.plan_id
    WHERE 
        u.username = username_input and s.end_date > now();
END;
$$ LANGUAGE plpgsql;

-- Função para calcular o valor total dos planos associados a um utilizador
CREATE OR REPLACE FUNCTION calculate_user_plans_total(user_id_input INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    total_price NUMERIC; -- Variável para armazenar o valor total
BEGIN
    -- Calcular o valor total dos planos associados ao utilizador
    SELECT COALESCE(SUM(p.price), 0)
    INTO total_price
    FROM Subscription s
    JOIN plan_subscription ps ON s.subscription_id = ps.subscription_id
    JOIN Plan p ON ps.plan_id = p.plan_id
    WHERE s.user_id = user_id_input and s.end_date > now();

    -- Retornar o valor total
    RETURN total_price;
END;
$$ LANGUAGE plpgsql;