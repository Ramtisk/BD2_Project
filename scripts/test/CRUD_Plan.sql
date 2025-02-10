-- ============================================================
-- Removendo funções antigas antes de recriar
-- ============================================================
DROP FUNCTION IF EXISTS sp_Plan_CREATE CASCADE;
DROP FUNCTION IF EXISTS sp_Plan_DELETE CASCADE;
DROP FUNCTION IF EXISTS TEST_Plan_CRUD CASCADE;

-- ============================================================
-- Função para criar ou atualizar um plano
-- ============================================================
CREATE OR REPLACE FUNCTION sp_Plan_CREATE(
    p_name TEXT,
    p_description TEXT,
    p_image TEXT,
    p_price FLOAT,
    p_service_type VARCHAR(10)
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se o plano já existe
    IF EXISTS (SELECT 1 FROM plan WHERE name = p_name) THEN
        -- Atualiza o plano existente
        UPDATE plan
        SET description = p_description, image = p_image, price = p_price, service_type = p_service_type
        WHERE name = p_name;
    ELSE
        -- Insere um novo plano
        INSERT INTO plan (name, description, image, price, service_type)
        VALUES (p_name, p_description, p_image, p_price, p_service_type);
    END IF;
END $$ LANGUAGE plpgsql;

-- ============================================================
-- Função para deletar um plano
-- ============================================================
CREATE OR REPLACE FUNCTION sp_Plan_DELETE(
    p_name TEXT
)
RETURNS VOID AS $$ 
BEGIN
    -- Verifica se o plano existe antes de excluir
    IF EXISTS (SELECT 1 FROM plan WHERE name = p_name) THEN
        DELETE FROM plan WHERE name = p_name;
    ELSE
        RAISE EXCEPTION 'Erro: Nenhum plano encontrado com o nome "%".', p_name;
    END IF;
END $$ LANGUAGE plpgsql;

-- ============================================================
-- Função para testar o CRUD do Plan
-- ============================================================
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
        PERFORM sp_Plan_CREATE('Plano Teste', 'Descrição Teste', NULL, 99.99, 'Internet');
        SELECT COUNT(*) INTO contador FROM plan WHERE name = 'Plano Teste';
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
        SELECT * INTO read_result FROM plan WHERE name = 'Plano Teste';
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
        PERFORM sp_Plan_CREATE('Plano Teste', 'Descrição Atualizada', NULL, 129.99, 'TV');
        SELECT * INTO read_result FROM plan WHERE name = 'Plano Teste';
        IF read_result.price = 129.99 THEN
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
        SELECT COUNT(*) INTO contador FROM plan WHERE name = 'Plano Teste';
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
SELECT TEST_Plan_CRUD();
