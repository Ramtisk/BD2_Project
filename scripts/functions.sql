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
    total_profit FLOAT; -- Variable to store the total profit
BEGIN
    SELECT COALESCE(SUM(p.price), 0)
    INTO total_profit
    FROM plan_subscription ps
    JOIN Plan p ON ps.plan_id = p.plan_id;

    -- Return the total profit
    RETURN total_profit;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_clientes()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM auth_user where is_staff=false and is_superuser=false and is_active=true);
END;
$$ LANGUAGE plpgsql;