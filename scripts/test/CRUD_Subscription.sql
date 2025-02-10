-- ===============================
-- DROP das funções para evitar conflitos
-- ===============================
DROP FUNCTION IF EXISTS sp_Subscription_CREATE(
    INTEGER, INTEGER, TIMESTAMP, TIMESTAMP
) CASCADE;

DROP FUNCTION IF EXISTS sp_Subscription_DELETE(
    INTEGER
) CASCADE;

DROP FUNCTION IF EXISTS TEST_Subscription_CRUD() CASCADE;

-- ===============================
-- Garantir que o usuário 999 existe antes da criação da assinatura
-- ===============================
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM auth_user WHERE id = 999) THEN
        INSERT INTO auth_user (id, username, password, email, is_active, is_staff, is_superuser, date_joined)
        VALUES (999, 'temp_user', 'temp_password', 'temp_user@email.com', TRUE, FALSE, FALSE, NOW());
    END IF;
END $$;

-- ===============================
-- Garantir que a sequência do subscription_id está correta
-- ===============================
SELECT setval(pg_get_serial_sequence('subscription', 'subscription_id'),
              COALESCE((SELECT MAX(subscription_id) FROM subscription), 0) + 1, FALSE);

-- ===============================
-- Função CREATE/UPDATE para Subscription
-- ===============================
CREATE OR REPLACE FUNCTION sp_Subscription_CREATE(
    p_user_id INTEGER,
    p_discount_id INTEGER DEFAULT NULL,
    p_start_date TIMESTAMP DEFAULT NOW(),
    p_end_date TIMESTAMP DEFAULT NOW() + INTERVAL '1 year'
)
RETURNS VOID AS $$ 
DECLARE
    existing_subscription_id INTEGER;
BEGIN
    -- Verificar se o usuário já tem uma assinatura
    SELECT subscription_id INTO existing_subscription_id 
    FROM subscription 
    WHERE user_id = p_user_id 
    ORDER BY subscription_id DESC LIMIT 1;

    IF existing_subscription_id IS NOT NULL THEN
        -- Atualizar a assinatura existente
        UPDATE subscription
        SET discount_id = p_discount_id, start_date = p_start_date, end_date = p_end_date
        WHERE subscription_id = existing_subscription_id;
    ELSE
        -- Criar nova assinatura
        INSERT INTO subscription (user_id, discount_id, start_date, end_date)
        VALUES (p_user_id, p_discount_id, p_start_date, p_end_date);
    END IF;
END $$ LANGUAGE plpgsql;

-- ===============================
-- Função DELETE para Subscription
-- ===============================
CREATE OR REPLACE FUNCTION sp_Subscription_DELETE(
    p_subscription_id INTEGER
)
RETURNS VOID AS $$ 
BEGIN
    DELETE FROM subscription WHERE subscription_id = p_subscription_id;
END $$ LANGUAGE plpgsql;

-- ===============================
-- Teste automatizado para Subscription
-- ===============================
CREATE OR REPLACE FUNCTION TEST_Subscription_CRUD()
RETURNS TEXT AS $$ 
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
    sub_id INTEGER;
BEGIN
    -- Limpar estado inicial
    DELETE FROM subscription WHERE user_id = 999;

    -- CREATE
    BEGIN
        PERFORM sp_Subscription_CREATE(999);
        SELECT subscription_id INTO sub_id FROM subscription WHERE user_id = 999;
        IF sub_id IS NOT NULL THEN
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
        SELECT * INTO read_result FROM subscription WHERE subscription_id = sub_id;
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
        PERFORM sp_Subscription_CREATE(999, 1);
        SELECT * INTO read_result FROM subscription WHERE subscription_id = sub_id;
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
        PERFORM sp_Subscription_DELETE(sub_id);
        SELECT COUNT(*) INTO contador FROM subscription WHERE subscription_id = sub_id;
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

-- ===============================
-- Executar o teste
-- ===============================
SELECT TEST_Subscription_CRUD();
