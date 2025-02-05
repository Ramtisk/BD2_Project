-- CRUD para Subscription

CREATE OR REPLACE FUNCTION sp_Subscription_CREATE(
    p_user_id INTEGER,
    p_discount_id INTEGER,
    p_start_date TIMESTAMP,
    p_end_date TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        INSERT INTO subscription (user_id, discount_id, start_date, end_date)
        VALUES (p_user_id, p_discount_id, p_start_date, p_end_date);
    EXCEPTION
        WHEN unique_violation THEN
            UPDATE subscription
            SET discount_id = p_discount_id, start_date = p_start_date, end_date = p_end_date
            WHERE user_id = p_user_id;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar subscrição: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Subscription_DELETE(
    p_subscription_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM subscription
        WHERE subscription_id = p_subscription_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir subscrição: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_Subscription_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM subscription WHERE user_id = 999;

    -- CREATE
    BEGIN
        PERFORM sp_Subscription_CREATE(999, NULL, NOW(), NOW() + INTERVAL '1 year');
        SELECT COUNT(*) INTO contador
        FROM subscription
        WHERE user_id = 999;
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
        SELECT * INTO read_result FROM subscription WHERE user_id = 999;
        IF read_result.subscription_id IS NOT NULL THEN
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
        PERFORM sp_Subscription_CREATE(999, 1, NOW(), NOW() + INTERVAL '2 years');
        SELECT * INTO read_result FROM subscription WHERE user_id = 999;
        IF read_result.discount_id = 1 THEN
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
        PERFORM sp_Subscription_DELETE(read_result.subscription_id);
        SELECT COUNT(*) INTO contador
        FROM subscription
        WHERE user_id = 999;
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
select TEST_Subscription_CRUD();