-- CRUD para Discount

CREATE OR REPLACE FUNCTION sp_Discount_CREATE(
    p_name TEXT,
    p_percent INTEGER,
    p_active BOOLEAN
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        INSERT INTO discount (name, percent, active)
        VALUES (p_name, p_percent, p_active);
    EXCEPTION
        WHEN unique_violation THEN
            UPDATE discount
            SET percent = p_percent, active = p_active
            WHERE name = p_name;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar desconto: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Discount_DELETE(
    p_name TEXT
)
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

CREATE OR REPLACE FUNCTION TEST_Discount_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM discount WHERE name = 'Desconto Teste';

    -- CREATE
    BEGIN
        PERFORM sp_Discount_CREATE('Desconto Teste', 10, TRUE);
        SELECT COUNT(*) INTO contador
        FROM discount
        WHERE name = 'Desconto Teste';
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
        SELECT * INTO read_result FROM discount WHERE name = 'Desconto Teste';
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
        PERFORM sp_Discount_CREATE('Desconto Teste', 20, TRUE);
        SELECT * INTO read_result FROM discount WHERE name = 'Desconto Teste';
        IF read_result.percent = 20 THEN
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
        PERFORM sp_Discount_DELETE('Desconto Teste');
        SELECT COUNT(*) INTO contador
        FROM discount
        WHERE name = 'Desconto Teste';
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
select TEST_Discount_CRUD();