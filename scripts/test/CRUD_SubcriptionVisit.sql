CREATE OR REPLACE FUNCTION sp_SubcriptionVisit_CREATE(
    p_subscription_id INTEGER,
    p_tecnical_visit_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir uma nova associação
        INSERT INTO subcription_visit (subscription_id, tecnical_visit_id)
        VALUES (p_subscription_id, p_tecnical_visit_id);
    EXCEPTION
        WHEN unique_violation THEN
            -- Se já existe, não faz nada (ou pode adicionar lógica adicional, se necessário)
            RAISE NOTICE 'Associação já existente.';
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar associação de SubcriptionVisit: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_SubcriptionVisit_READ(
    p_subscription_id INTEGER,
    p_tecnical_visit_id INTEGER
)
RETURNS TABLE(subcription_visit_id INTEGER, subscription_id INTEGER, tecnical_visit_id INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT
        sv.subcription_visit_id::INTEGER,
        sv.subscription_id::INTEGER,
        sv.tecnical_visit_id::INTEGER
    FROM subcription_visit sv
    WHERE sv.subscription_id = p_subscription_id AND sv.tecnical_visit_id = p_tecnical_visit_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_SubcriptionVisit_DELETE(
    p_subscription_id INTEGER,
    p_tecnical_visit_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM subcription_visit
        WHERE subscription_id = p_subscription_id AND tecnical_visit_id = p_tecnical_visit_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir associação de SubcriptionVisit: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_SubcriptionVisit_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM subcription_visit WHERE subscription_id = 1 AND tecnical_visit_id = 1;

    -- CREATE
    BEGIN
        PERFORM sp_SubcriptionVisit_CREATE(1, 1);
        SELECT COUNT(*) INTO contador
        FROM subcription_visit
        WHERE subscription_id = 1 AND tecnical_visit_id = 1;
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
        SELECT * INTO read_result FROM sp_SubcriptionVisit_READ(1, 1);
        IF read_result.subcription_visit_id IS NOT NULL THEN
            resultado := resultado || ' READ: OK;';
        ELSE
            RETURN resultado || ' READ: NOK;';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN resultado || ' READ: NOK; Erro inesperado: ' || SQLERRM;
    END;

    -- DELETE
    BEGIN
        PERFORM sp_SubcriptionVisit_DELETE(1, 1);
        SELECT COUNT(*) INTO contador
        FROM subcription_visit
        WHERE subscription_id = 1 AND tecnical_visit_id = 1;
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

SELECT TEST_SubcriptionVisit_CRUD();
