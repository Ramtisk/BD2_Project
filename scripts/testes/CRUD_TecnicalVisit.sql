CREATE OR REPLACE FUNCTION sp_TechnicalVisit_CREATE(
    p_tecnical_id INTEGER,
    p_device_id INTEGER,
    p_note TEXT,
    p_date TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir uma nova visita técnica
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
    WHERE tv.tecnical_id = p_tecnical_id AND tv.device_id = p_device_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_TechnicalVisit_UPDATE(
    p_tecnical_id INTEGER,
    p_device_id INTEGER,
    p_new_note TEXT,
    p_new_date TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE tecnical_visit
        SET note = p_new_note, date = p_new_date
        WHERE tecnical_id = p_tecnical_id AND device_id = p_device_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar visita técnica: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_TechnicalVisit_DELETE(
    p_tecnical_id INTEGER,
    p_device_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM tecnical_visit
        WHERE tecnical_id = p_tecnical_id AND device_id = p_device_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao excluir visita técnica: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TEST_TechnicalVisit_CRUD()
RETURNS TEXT AS $$
DECLARE
    read_result RECORD;
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Limpar estado inicial
    DELETE FROM tecnical_visit WHERE tecnical_id = 1 AND device_id = 1;

    -- CREATE
    BEGIN
        PERFORM sp_TechnicalVisit_CREATE(1, 1, 'Instalação realizada com sucesso', '2023-01-01 10:00:00');
        SELECT COUNT(*) INTO contador
        FROM tecnical_visit
        WHERE tecnical_id = 1 AND device_id = 1;
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
        SELECT * INTO read_result FROM sp_TechnicalVisit_READ(1, 1);
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
        PERFORM sp_TechnicalVisit_UPDATE(1, 1, 'Manutenção realizada', '2023-02-01 10:00:00');
        SELECT * INTO read_result FROM sp_TechnicalVisit_READ(1, 1);
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
        SELECT COUNT(*) INTO contador
        FROM tecnical_visit
        WHERE tecnical_id = 1 AND device_id = 1;
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

SELECT TEST_TechnicalVisit_CRUD();
