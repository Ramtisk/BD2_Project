-- Procedure para gerar um pagamento somando os valores dos planos associados a uma subscrição com desconto
CREATE OR REPLACE PROCEDURE generate_payment(subscription_id INT)
LANGUAGE plpgsql AS $$
DECLARE
    total_amount NUMERIC := 0;
    discount_percent NUMERIC := 0;
BEGIN
    -- Calcular o total dos preços dos planos associados à subscrição
    SELECT SUM(p.price)
    INTO total_amount
    FROM plan p
    JOIN plan_subscription ps ON p.plan_id = ps.plan_id
    WHERE ps.subscription_id = subscription_id;

    -- Verificar se há desconto associado à subscrição
    SELECT d.percent
    INTO discount_percent
    FROM subscription s
    LEFT JOIN discount d ON s.discount_id = d.discount_id
    WHERE s.subscription_id = subscription_id;

    -- Aplicar desconto se existir
    IF discount_percent IS NOT NULL THEN
        total_amount := total_amount * ((100 - discount_percent) / 100);
    END IF;

    -- Inserir o pagamento na tabela
    INSERT INTO payment (subscription_id, user_id, amount, date)
    SELECT subscription_id, user_id, total_amount, NOW()
    FROM subscription
    WHERE subscription_id = subscription_id;
END;
$$;

CREATE OR REPLACE FUNCTION get_clientes_mes_atual()
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(*) 
        FROM auth_user 
        WHERE DATE_PART('year', date_joined) = DATE_PART('year', CURRENT_DATE)
          AND DATE_PART('month', date_joined) = DATE_PART('month', CURRENT_DATE)
		  AND is_staff=false 
		  AND is_superuser=false
		  AND is_active=true
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_clientes()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM auth_user where is_staff=false and is_superuser=false and is_active=true);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE generate_payment()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD; -- Variável para armazenar cada linha do resultado da query
    total_amount FLOAT; -- Variável para armazenar o valor total com descontos
    new_end_date TIMESTAMP; -- Variável para o novo end_date
    random_entity TEXT; -- Variável para armazenar uma entidade aleatória
    random_reference TEXT; -- Variável para armazenar uma referência aleatória
BEGIN
    FOR rec IN
        SELECT 
            s.subscription_id,
            s.user_id,
            SUM(p.price * (1 - COALESCE(d.percent, 0) / 100.0)) AS total_amount -- Aplica o desconto
        FROM Subscription s
        JOIN plan_subscription ps ON s.subscription_id = ps.subscription_id
        JOIN Plan p ON ps.plan_id = p.plan_id
        LEFT JOIN Discount d ON s.discount_id = d.discount_id
        WHERE s.end_date >= NOW()
        GROUP BY s.subscription_id, s.user_id
    LOOP
        total_amount := rec.total_amount;

        new_end_date := DATE_TRUNC('month', NOW()) + INTERVAL '1 month';

        random_entity := TRUNC(RANDOM() * 1000)::TEXT;
        random_reference := MD5(RANDOM()::TEXT);

        INSERT INTO Payment (subscription_id, user_id, amount, date, entity, refence)
        VALUES (rec.subscription_id, rec.user_id, total_amount, NOW(), random_entity, random_reference);

        UPDATE Subscription
        SET end_date = new_end_date
        WHERE subscription_id = rec.subscription_id;
    END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE adjust_all_sequences()
LANGUAGE plpgsql
AS $$
DECLARE 
    r RECORD;
BEGIN 
    FOR r IN (
        SELECT c.oid::regclass AS table_name, 
               a.attname AS column_name, 
               pg_get_serial_sequence(c.oid::regclass::text, a.attname) AS sequence_name 
        FROM pg_class c
        JOIN pg_attribute a ON c.oid = a.attrelid 
        WHERE c.relkind = 'r' 
        AND a.attnum > 0 
        AND NOT a.attisdropped -- Evita colunas deletadas
        AND pg_get_serial_sequence(c.oid::regclass::text, a.attname) IS NOT NULL
    ) 
    LOOP 
        EXECUTE format(
            'SELECT setval(''%s'', COALESCE((SELECT MAX(%I) FROM %I), 0) + 1, false);', 
            r.sequence_name, r.column_name, r.table_name
        );
    END LOOP; 
END $$;