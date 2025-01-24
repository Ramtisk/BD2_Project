-- CREATE Function: sp_Discount_UPDATE
CREATE OR REPLACE FUNCTION sp_Discount_UPDATE(
    p_name TEXT,
    p_new_percent INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE discount
        SET percent = p_new_percent
        WHERE name = p_name;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar desconto: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

-- CREATE Function: sp_Discount_DELETE
CREATE OR REPLACE FUNCTION sp_Discount_DELETE(p_name TEXT)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM discount
        WHERE name = p_name;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir desconto: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

-- Test Procedure: TEST_Discount_CRUD
CREATE OR REPLACE FUNCTION TEST_Discount_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM discount WHERE name = 'Test Discount';

    -- CREATE
    BEGIN
        PERFORM sp_Discount_CREATE('Test Discount', 15, TRUE);
        SELECT COUNT(*) INTO contador
        FROM discount
        WHERE name = 'Test Discount';
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
        SELECT * INTO read_result FROM sp_Discount_READ('Test Discount');
        IF read_result.discount_id IS NOT NULL THEN
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
        PERFORM sp_Discount_UPDATE('Test Discount', 20);
        SELECT * INTO read_result FROM sp_Discount_READ('Test Discount');
        IF read_result.percent = 20 AND read_result.active = TRUE THEN
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
        PERFORM sp_Discount_DELETE('Test Discount');
        SELECT COUNT(*) INTO contador
        FROM discount
        WHERE name = 'Test Discount';
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

-- Executar Teste
SELECT TEST_Discount_CRUD();
