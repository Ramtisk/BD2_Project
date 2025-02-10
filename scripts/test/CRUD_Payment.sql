-- ============================================================
-- Removendo funções antigas antes de recriar
-- ============================================================
DROP FUNCTION IF EXISTS sp_Payment_CREATE CASCADE;
DROP FUNCTION IF EXISTS sp_Payment_READ CASCADE;
DROP FUNCTION IF EXISTS sp_Payment_UPDATE CASCADE;
DROP FUNCTION IF EXISTS sp_Payment_DELETE CASCADE;
DROP FUNCTION IF EXISTS TEST_Payment_CRUD CASCADE;

-- ============================================================
-- NOTA: 
-- O erro de escrita na coluna "refence" foi identificado,
-- mas optamos por manter essa nomenclatura para evitar alterações estruturais.
-- ============================================================

-- Criar a constraint UNIQUE apenas se ela ainda não existir
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_subscription_user' 
        AND table_name = 'payment'
    ) THEN
        ALTER TABLE payment ADD CONSTRAINT unique_subscription_user UNIQUE (subscription_id, user_id);
    END IF;
END $$;

-- ============================================================
-- Função para criar ou atualizar um pagamento
-- ============================================================
CREATE OR REPLACE FUNCTION sp_Payment_CREATE(
    p_subscription_id INTEGER,
    p_user_id INTEGER,
    p_amount FLOAT,
    p_date TIMESTAMP,
    p_entity TEXT,
    p_refence TEXT  -- Mantendo "refence"
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se subscription e usuário existem antes de inserir
    IF NOT EXISTS (SELECT 1 FROM subscription WHERE subscription_id = p_subscription_id) THEN
        RAISE EXCEPTION 'Erro: A subscription_id "%" não existe.', p_subscription_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM auth_user WHERE id = p_user_id) THEN
        RAISE EXCEPTION 'Erro: O user_id "%" não existe.', p_user_id;
    END IF;

    -- Insere ou atualiza evitando duplicação
    INSERT INTO payment (subscription_id, user_id, amount, date, entity, refence)
    VALUES (p_subscription_id, p_user_id, p_amount, p_date, p_entity, p_refence)
    ON CONFLICT (subscription_id, user_id) 
    DO UPDATE 
    SET amount = EXCLUDED.amount, date = EXCLUDED.date, entity = EXCLUDED.entity, refence = EXCLUDED.refence;
END $$ LANGUAGE plpgsql;

-- ============================================================
-- Função para ler um pagamento
-- ============================================================
CREATE OR REPLACE FUNCTION sp_Payment_READ(
    p_subscription_id INTEGER,
    p_user_id INTEGER
)
RETURNS TABLE(payment_id INTEGER, subscription_id INTEGER, user_id INTEGER, amount FLOAT, date TIMESTAMP, entity TEXT, refence TEXT) AS $$ 
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

-- ============================================================
-- Função para atualizar um pagamento
-- ============================================================
CREATE OR REPLACE FUNCTION sp_Payment_UPDATE(
    p_subscription_id INTEGER,
    p_user_id INTEGER,
    p_new_amount FLOAT,
    p_new_date TIMESTAMP,
    p_new_entity TEXT,
    p_new_refence TEXT
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se o pagamento existe antes de atualizar
    IF NOT EXISTS (SELECT 1 FROM payment WHERE subscription_id = p_subscription_id AND user_id = p_user_id) THEN
        RAISE EXCEPTION 'Erro: Nenhum pagamento encontrado para subscription_id "%" e user_id "%".', p_subscription_id, p_user_id;
    END IF;

    -- Atualiza os dados do pagamento
    UPDATE payment
    SET amount = p_new_amount, date = p_new_date, entity = p_new_entity, refence = p_new_refence
    WHERE subscription_id = p_subscription_id AND user_id = p_user_id;
END $$ LANGUAGE plpgsql;

-- ============================================================
-- Função para deletar um pagamento
-- ============================================================
CREATE OR REPLACE FUNCTION sp_Payment_DELETE(
    p_subscription_id INTEGER,
    p_user_id INTEGER
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se o pagamento existe antes de excluir
    IF EXISTS (SELECT 1 FROM payment WHERE subscription_id = p_subscription_id AND user_id = p_user_id) THEN
        DELETE FROM payment WHERE subscription_id = p_subscription_id AND user_id = p_user_id;
    ELSE
        RAISE EXCEPTION 'Erro: Nenhum pagamento encontrado para subscription_id "%" e user_id "%".', p_subscription_id, p_user_id;
    END IF;
END $$ LANGUAGE plpgsql;

-- ============================================================
-- Função para testar o CRUD do Payment
-- ============================================================
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
        PERFORM sp_Payment_CREATE(1, 1, 100.50, '2025-02-08 10:00:00', 'Banco A', 'REF123');
        SELECT COUNT(*) INTO contador FROM payment WHERE subscription_id = 1 AND user_id = 1;
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
        PERFORM sp_Payment_UPDATE(1, 1, 200.75, '2025-02-10 15:00:00', 'Banco B', 'REF456');
        SELECT * INTO read_result FROM sp_Payment_READ(1, 1);
        IF read_result.amount = 200.75 AND read_result.date = '2025-02-10 15:00:00' AND read_result.entity = 'Banco B' THEN
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
        SELECT COUNT(*) INTO contador FROM payment WHERE subscription_id = 1 AND user_id = 1;
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

-- Executar teste
SELECT TEST_Payment_CRUD();
