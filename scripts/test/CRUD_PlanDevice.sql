-- Remover funções caso já existam
DROP FUNCTION IF EXISTS sp_PlanDevice_CREATE CASCADE;
DROP FUNCTION IF EXISTS sp_PlanDevice_READ CASCADE;
DROP FUNCTION IF EXISTS sp_PlanDevice_UPDATE CASCADE;
DROP FUNCTION IF EXISTS sp_PlanDevice_DELETE CASCADE;
DROP FUNCTION IF EXISTS TEST_PlanDevice_CRUD CASCADE;

-- Criar função de criação de relação entre plano e dispositivo
CREATE OR REPLACE FUNCTION sp_PlanDevice_CREATE(
    p_plan_id INTEGER,
    p_device_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        INSERT INTO plan_device (plan_id, device_id)
        VALUES (p_plan_id, p_device_id);
    EXCEPTION
        WHEN unique_violation THEN
            RAISE NOTICE 'Relação entre plano e dispositivo já existe.';
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar relação entre plano e dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

-- Criar função de leitura de relação entre plano e dispositivo
CREATE OR REPLACE FUNCTION sp_PlanDevice_READ(
    p_plan_id INTEGER,
    p_device_id INTEGER
)
RETURNS TABLE(plan_device_id INTEGER, plan_id INTEGER, device_id INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT pd.plan_device_id, pd.plan_id, pd.device_id
    FROM plan_device pd
    WHERE pd.plan_id = p_plan_id AND pd.device_id = p_device_id;
END $$ LANGUAGE plpgsql;

-- Criar função de atualização de relação entre plano e dispositivo
CREATE OR REPLACE FUNCTION sp_PlanDevice_UPDATE(
    p_plan_device_id INTEGER,
    p_new_plan_id INTEGER,
    p_new_device_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE plan_device
        SET plan_id = p_new_plan_id, device_id = p_new_device_id
        WHERE plan_device_id = p_plan_device_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar relação entre plano e dispositivo: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

-- Criar função de deleção de relação entre plano e dispositivo
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

-- Criar função de testes para verificar funcionamento das operações CRUD
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
        SELECT COUNT(*) INTO contador FROM plan_device WHERE plan_id = 1 AND device_id = 1;
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

    -- UPDATE
    BEGIN
        PERFORM sp_PlanDevice_UPDATE(read_result.plan_device_id, 2, 2);
        SELECT * INTO read_result FROM sp_PlanDevice_READ(2, 2);
        IF read_result.plan_device_id IS NOT NULL AND read_result.plan_id = 2 AND read_result.device_id = 2 THEN
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
        PERFORM sp_PlanDevice_DELETE(2, 2);
        SELECT COUNT(*) INTO contador FROM plan_device WHERE plan_id = 2 AND device_id = 2;
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
SELECT TEST_PlanDevice_CRUD();
