CREATE OR REPLACE FUNCTION sp_PlanDevice_CREATE(
    p_plan_id INTEGER,
    p_device_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir uma nova relação entre plano e dispositivo
        INSERT INTO plan_device (plan_id, device_id)
        VALUES (p_plan_id, p_device_id);
    EXCEPTION
        WHEN unique_violation THEN
            -- Relação já existe
            RAISE NOTICE 'Relação entre plano e dispositivo já existe.';
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar relação entre plano e dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_PlanDevice_READ(
    p_plan_id INTEGER,
    p_device_id INTEGER
)
RETURNS TABLE(plan_device_id INTEGER, plan_id INTEGER, device_id INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pd.plan_device_id::INTEGER,
        pd.plan_id::INTEGER,
        pd.device_id::INTEGER
    FROM plan_device pd
    WHERE pd.plan_id = p_plan_id AND pd.device_id = p_device_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_PlanDevice_DELETE(
    p_plan_id INTEGER,
    p_device_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM plan_device
        WHERE plan_id = p_plan_id AND device_id = p_device_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir relação entre plano e dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_PlanDevice_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM plan_device WHERE plan_id = 1 AND device_id = 1;

    -- CREATE
    BEGIN
        PERFORM sp_PlanDevice_CREATE(1, 1);
        SELECT COUNT(*) INTO contador
        FROM plan_device
        WHERE plan_id = 1 AND device_id = 1;
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
        SELECT * INTO read_result FROM sp_PlanDevice_READ(1, 1);
        IF read_result.plan_device_id IS NOT NULL THEN
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
        PERFORM sp_PlanDevice_DELETE(1, 1);
        SELECT COUNT(*) INTO contador
        FROM plan_device
        WHERE plan_id = 1 AND device_id = 1;
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

SELECT TEST_PlanDevice_CRUD();