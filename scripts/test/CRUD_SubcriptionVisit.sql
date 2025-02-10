-- ============================================================
-- Removendo funções antigas antes de recriar
-- ============================================================
DROP FUNCTION IF EXISTS sp_SubcriptionVisit_CREATE CASCADE;
DROP FUNCTION IF EXISTS sp_SubcriptionVisit_READ CASCADE;
DROP FUNCTION IF EXISTS sp_SubcriptionVisit_DELETE CASCADE;
DROP FUNCTION IF EXISTS TEST_SubcriptionVisit_CRUD CASCADE;

-- ============================================================
-- Função para Criar uma associação entre Subscription e Tecnical Visit
-- ============================================================
CREATE OR REPLACE FUNCTION sp_SubcriptionVisit_CREATE(
    p_subscription_id INTEGER,
    p_tecnical_visit_id INTEGER
)
RETURNS TEXT AS $$ 
DECLARE
    existe INTEGER;
BEGIN
    -- Verifica se a relação já existe para evitar erro de chave duplicada
    SELECT COUNT(*) INTO existe
    FROM subcription_visit 
    WHERE subscription_id = p_subscription_id 
    AND tecnical_visit_id = p_tecnical_visit_id;

    IF existe > 0 THEN
        RETURN 'CREATE: NOK; Erro: Associação já existente.';
    END IF;

    -- Insere a nova relação
    INSERT INTO subcription_visit (subscription_id, tecnical_visit_id)
    VALUES (p_subscription_id, p_tecnical_visit_id);

    RETURN 'CREATE: OK;';
END $$ LANGUAGE plpgsql;

-- ============================================================
-- Função para Ler uma associação entre Subscription e Tecnical Visit
-- ============================================================
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

-- ============================================================
-- Função para Deletar uma associação entre Subscription e Tecnical Visit
-- ============================================================
CREATE OR REPLACE FUNCTION sp_SubcriptionVisit_DELETE(
    p_subscription_id INTEGER,
    p_tecnical_visit_id INTEGER
)
RETURNS TEXT AS $$ 
DECLARE
    existe INTEGER;
BEGIN
    -- Verifica se o registro existe antes de tentar excluir
    SELECT COUNT(*) INTO existe
    FROM subcription_visit 
    WHERE subscription_id = p_subscription_id 
    AND tecnical_visit_id = p_tecnical_visit_id;

    IF existe = 0 THEN
        RETURN 'DELETE: NOK; Erro: Associação não encontrada.';
    END IF;

    DELETE FROM subcription_visit
    WHERE subscription_id = p_subscription_id 
    AND tecnical_visit_id = p_tecnical_visit_id;

    RETURN 'DELETE: OK;';
END $$ LANGUAGE plpgsql;

-- ============================================================
-- Função para Testar o CRUD da Tabela `subcription_visit`
-- ============================================================
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
        resultado := sp_SubcriptionVisit_CREATE(1, 1);
        SELECT COUNT(*) INTO contador FROM subcription_visit WHERE subscription_id = 1 AND tecnical_visit_id = 1;
        IF contador > 0 THEN
            resultado := resultado || ' CREATE: OK;';
        ELSE
            RETURN resultado || ' CREATE: NOK;';
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
        resultado := resultado || ' ' || sp_SubcriptionVisit_DELETE(1, 1);
        SELECT COUNT(*) INTO contador FROM subcription_visit WHERE subscription_id = 1 AND tecnical_visit_id = 1;
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

-- Executar teste para validar CRUD
SELECT TEST_SubcriptionVisit_CRUD();
