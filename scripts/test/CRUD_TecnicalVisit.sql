-- ======================================================
-- DROP das funções antes de recriá-las (para evitar conflitos)
-- ======================================================
DROP FUNCTION IF EXISTS sp_TechnicalVisit_CREATE(INTEGER, INTEGER, TEXT, TIMESTAMP) CASCADE;
DROP FUNCTION IF EXISTS sp_TechnicalVisit_READ(INTEGER, INTEGER) CASCADE;
DROP FUNCTION IF EXISTS sp_TechnicalVisit_UPDATE(INTEGER, INTEGER, TEXT, TIMESTAMP) CASCADE;
DROP FUNCTION IF EXISTS sp_TechnicalVisit_DELETE(INTEGER, INTEGER) CASCADE;
DROP FUNCTION IF EXISTS TEST_TechnicalVisit_CRUD() CASCADE;

-- ======================================================
-- Função CREATE para Technical Visit
-- ======================================================
CREATE OR REPLACE FUNCTION sp_TechnicalVisit_CREATE(
    p_tecnical_id INTEGER,
    p_device_id INTEGER,
    p_note TEXT,
    p_date TIMESTAMP WITHOUT TIME ZONE
)
RETURNS VOID AS $$ 
BEGIN
    BEGIN
        -- Inserir uma nova visita técnica
        INSERT INTO tecnical_visit (tecnical_id, device_id, note, date)
        VALUES (p_tecnical_id, p_device_id, p_note, p_date);
    EXCEPTION
        WHEN unique_violation THEN
            -- Atualizar a visita técnica existente
            UPDATE tecnical_visit
            SET note = p_note, date = p_date
            WHERE tecnical_id = p_tecnical_id AND device_id = p_device_id;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar visita técnica: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

-- ======================================================
-- Função READ para Technical Visit
-- ======================================================
CREATE OR REPLACE FUNCTION sp_TechnicalVisit_READ(
    p_tecnical_id INTEGER,
    p_device_id INTEGER
)
RETURNS TABLE(tecnical_visit_id INTEGER, tecnical_id INTEGER, device_id INTEGER, note TEXT, date TIMESTAMP) AS $$ 
BEGIN
    RETURN QUERY
    SELECT 
        tv.tecnical_visit_id::INTEGER,
        tv.tecnical_id::INTEGER,
        tv.device_id::INTEGER,
        tv.note::TEXT,
        tv.date::TIMESTAMP
    FROM tecnical_visit tv
    WHERE tv.tecnical_id = p_tecnical_id 
      AND (p_device_id IS NULL OR tv.device_id = p_device_id);
END $$ LANGUAGE plpgsql;

-- ======================================================
-- Função UPDATE para Technical Visit
-- ======================================================
CREATE OR REPLACE FUNCTION sp_TechnicalVisit_UPDATE(
    p_tecnical_id INTEGER,
    p_device_id INTEGER,
    p_new_note TEXT,
    p_new_date TIMESTAMP WITHOUT TIME ZONE
)
RETURNS VOID AS $$ 
BEGIN
    BEGIN
        -- Atualizar a visita técnica
        UPDATE tecnical_visit
        SET note = p_new_note, date = p_new_date
        WHERE tecnical_id = p_tecnical_id 
          AND (p_device_id IS NULL OR device_id = p_device_id);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar visita técnica: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

-- ======================================================
-- Função DELETE para Technical Visit
-- ======================================================
CREATE OR REPLACE FUNCTION sp_TechnicalVisit_DELETE(
    p_tecnical_id INTEGER,
    p_device_id INTEGER
)
RETURNS VOID AS $$ 
BEGIN
    BEGIN
        -- Deletar a visita técnica
        DELETE FROM tecnical_visit
        WHERE tecnical_id = p_tecnical_id 
          AND (p_device_id IS NULL OR device_id = p_device_id);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir visita técnica: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

-- ======================================================
-- Função de Teste Completo para CRUD Technical Visit
-- ======================================================
CREATE OR REPLACE FUNCTION TEST_TechnicalVisit_CRUD()
RETURNS TEXT AS $$ 
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
    visit_id INTEGER;
BEGIN
    -- Limpar estado inicial
    DELETE FROM tecnical_visit WHERE tecnical_id = 1 AND device_id = 1;

    -- CREATE
    BEGIN
        PERFORM sp_TechnicalVisit_CREATE(1, 1, 'Instalação realizada com sucesso', '2023-01-01 10:00:00'::TIMESTAMP WITHOUT TIME ZONE);
        SELECT tecnical_visit_id INTO visit_id FROM tecnical_visit WHERE tecnical_id = 1 AND device_id = 1;
        IF visit_id IS NOT NULL THEN
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
        SELECT * INTO read_result FROM tecnical_visit WHERE tecnical_visit_id = visit_id;
        IF read_result.tecnical_visit_id IS NOT NULL THEN
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
        PERFORM sp_TechnicalVisit_UPDATE(1, 1, 'Manutenção realizada', '2023-02-01 10:00:00'::TIMESTAMP WITHOUT TIME ZONE);
        SELECT * INTO read_result FROM tecnical_visit WHERE tecnical_visit_id = visit_id;
        IF read_result.note = 'Manutenção realizada' AND read_result.date = '2023-02-01 10:00:00' THEN
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
        PERFORM sp_TechnicalVisit_DELETE(1, 1);
        SELECT COUNT(*) INTO contador FROM tecnical_visit WHERE tecnical_visit_id = visit_id;
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

-- ======================================================
-- Executar o teste
-- ======================================================
SELECT TEST_TechnicalVisit_CRUD();
