CREATE OR REPLACE FUNCTION sp_Plan_CREATE(
    p_name TEXT,
    p_description TEXT,
    p_price FLOAT,
    p_service_type TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir um novo plano
        INSERT INTO plan (name, description, price, service_type)
        VALUES (p_name, p_description, p_price, p_service_type);
    EXCEPTION
        WHEN unique_violation THEN
            -- Atualizar o plano existente
            UPDATE plan
            SET description = p_description, price = p_price, service_type = p_service_type
            WHERE name = p_name;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar plano: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Plan_READ(
    p_name TEXT
)
RETURNS TABLE(plan_id INTEGER, name TEXT, description TEXT, price FLOAT, service_type TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.plan_id::INTEGER,            -- Casting explícito para garantir o tipo correto
        p.name::TEXT,
        p.description::TEXT,
        p.price::FLOAT,
        p.service_type::TEXT
    FROM plan p
    WHERE p.name = p_name;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Plan_UPDATE(
    p_name TEXT,
    p_new_description TEXT,
    p_new_price FLOAT,
    p_new_service_type TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE plan
        SET description = p_new_description, price = p_new_price, service_type = p_new_service_type
        WHERE name = p_name;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar plano: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Plan_DELETE(
    p_name TEXT
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM plan
        WHERE name = p_name;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir plano: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_Plan_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM plan WHERE name = 'Plano Teste';

    -- CREATE
    BEGIN
        PERFORM sp_Plan_CREATE('Plano Teste', 'Plano de teste', 29.99, 'Internet');
        SELECT COUNT(*) INTO contador
        FROM plan
        WHERE name = 'Plano Teste';
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
        SELECT * INTO read_result FROM sp_Plan_READ('Plano Teste');
        IF read_result.plan_id IS NOT NULL THEN
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
        PERFORM sp_Plan_UPDATE('Plano Teste', 'Plano Atualizado', 39.99, 'TV');
        SELECT * INTO read_result FROM sp_Plan_READ('Plano Teste');
        IF read_result.description = 'Plano Atualizado' AND read_result.price = 39.99 AND read_result.service_type = 'TV' THEN
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
        PERFORM sp_Plan_DELETE('Plano Teste');
        SELECT COUNT(*) INTO contador
        FROM plan
        WHERE name = 'Plano Teste';
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

SELECT TEST_Plan_CRUD();