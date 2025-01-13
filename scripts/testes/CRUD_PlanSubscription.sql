CREATE OR REPLACE FUNCTION sp_PlanSubscription_CREATE(
    p_plan_id INTEGER,
    p_subscription_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir uma nova relação
        INSERT INTO plan_subscription (plan_id, subscription_id)
        VALUES (p_plan_id, p_subscription_id);
    EXCEPTION
        WHEN unique_violation THEN
            -- Relação já existe
            RAISE NOTICE 'Relação entre plano e assinatura já existe.';
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar relação entre plano e assinatura: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_PlanSubscription_READ(
    p_plan_id INTEGER,
    p_subscription_id INTEGER
)
RETURNS TABLE(plan_subscription_id INTEGER, plan_id INTEGER, subscription_id INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ps.plan_subscription_id::INTEGER,
        ps.plan_id::INTEGER,
        ps.subscription_id::INTEGER
    FROM plan_subscription ps
    WHERE ps.plan_id = p_plan_id AND ps.subscription_id = p_subscription_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_PlanSubscription_DELETE(
    p_plan_id INTEGER,
    p_subscription_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM plan_subscription
        WHERE plan_id = p_plan_id AND subscription_id = p_subscription_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir relação entre plano e assinatura: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_PlanSubscription_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM plan_subscription WHERE plan_id = 1 AND subscription_id = 1;

    -- CREATE
    BEGIN
        PERFORM sp_PlanSubscription_CREATE(1, 1);
        SELECT COUNT(*) INTO contador
        FROM plan_subscription
        WHERE plan_id = 1 AND subscription_id = 1;
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
        SELECT * INTO read_result FROM sp_PlanSubscription_READ(1, 1);
        IF read_result.plan_subscription_id IS NOT NULL THEN
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
        PERFORM sp_PlanSubscription_DELETE(1, 1);
        SELECT COUNT(*) INTO contador
        FROM plan_subscription
        WHERE plan_id = 1 AND subscription_id = 1;
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

SELECT TEST_PlanSubscription_CRUD();
