CREATE OR REPLACE FUNCTION sp_Payment_CREATE(
    p_subscription_id INTEGER,
    p_user_id INTEGER,
    p_amount FLOAT,
    p_date TIMESTAMP,
    p_entity TEXT,
    p_reference TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir um novo pagamento
        INSERT INTO payment (subscription_id, user_id, amount, date, entity, refence)
        VALUES (p_subscription_id, p_user_id, p_amount, p_date, p_entity, p_reference);
    EXCEPTION
        WHEN unique_violation THEN
            -- Atualizar o pagamento existente
            UPDATE payment
            SET amount = p_amount, date = p_date, entity = p_entity, refence = p_reference
            WHERE subscription_id = p_subscription_id AND user_id = p_user_id;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar pagamento: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Payment_READ(
    p_subscription_id INTEGER,
    p_user_id INTEGER
)
RETURNS TABLE(payment_id INTEGER, subscription_id INTEGER, user_id INTEGER, amount FLOAT, date TIMESTAMP, entity TEXT, reference TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.payment_id::INTEGER,
        p.subscription_id::INTEGER,
        p.user_id::INTEGER,
        p.amount::FLOAT,
        p.date::TIMESTAMP,
        p.entity::TEXT,
        p.refence::TEXT
    FROM payment p
    WHERE p.subscription_id = p_subscription_id AND p.user_id = p_user_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Payment_UPDATE(
    p_subscription_id INTEGER,
    p_user_id INTEGER,
    p_new_amount FLOAT,
    p_new_date TIMESTAMP,
    p_new_entity TEXT,
    p_new_reference TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE payment
        SET amount = p_new_amount, date = p_new_date, entity = p_new_entity, refence = p_new_reference
        WHERE subscription_id = p_subscription_id AND user_id = p_user_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar pagamento: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Payment_DELETE(
    p_subscription_id INTEGER,
    p_user_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM payment
        WHERE subscription_id = p_subscription_id AND user_id = p_user_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir pagamento: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_Payment_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM payment WHERE subscription_id = 1 AND user_id = 1;

    -- CREATE
    BEGIN
        PERFORM sp_Payment_CREATE(1, 1, 100.50, '2023-01-01 10:00:00', 'Banco A', 'REF123');
        SELECT COUNT(*) INTO contador
        FROM payment
        WHERE subscription_id = 1 AND user_id = 1;
        IF contador > 0 THEN
            resultado := 'CREATE: OK;';
        ELSE
            RETURN 'CREATE: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'CREATE: NOK; Erro inesperado: ' || SQLERRM;
    END;

    -- READ
    BEGIN
        SELECT * INTO read_result FROM sp_Payment_READ(1, 1);
        IF read_result.payment_id IS NOT NULL THEN
            resultado := resultado || ' READ: OK;';
        ELSE
            RETURN resultado || ' READ: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN resultado || ' READ: NOK; Erro inesperado: ' || SQLERRM;
    END;

    -- UPDATE
    BEGIN
        PERFORM sp_Payment_UPDATE(1, 1, 200.75, '2023-02-01 10:00:00', 'Banco B', 'REF456');
        SELECT * INTO read_result FROM sp_Payment_READ(1, 1);
        IF read_result.amount = 200.75 AND read_result.date = '2023-02-01 10:00:00' AND read_result.entity = 'Banco B' THEN
            resultado := resultado || ' UPDATE: OK;';
        ELSE
            RETURN resultado || ' UPDATE: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN resultado || ' UPDATE: NOK; Erro inesperado: ' || SQLERRM;
    END;

    -- DELETE
    BEGIN
        PERFORM sp_Payment_DELETE(1, 1);
        SELECT COUNT(*) INTO contador
        FROM payment
        WHERE subscription_id = 1 AND user_id = 1;
        IF contador = 0 THEN
            resultado := resultado || ' DELETE: OK;';
        ELSE
            RETURN resultado || ' DELETE: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN resultado || ' DELETE: NOK; Erro inesperado: ' || SQLERRM;
    END;

    RETURN resultado;
END $$ LANGUAGE plpgsql;

SELECT TEST_Payment_CRUD();
