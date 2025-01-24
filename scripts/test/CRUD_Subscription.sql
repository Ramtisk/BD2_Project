CREATE OR REPLACE FUNCTION sp_Subscription_CREATE(
    p_user_id INTEGER,
    p_discount_id INTEGER,
    p_start_date TIMESTAMP,
    p_end_date TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        -- Tentar inserir uma nova assinatura
        INSERT INTO subscription (user_id, discount_id, start_date, end_date)
        VALUES (p_user_id, p_discount_id, p_start_date, p_end_date);
    EXCEPTION
        WHEN unique_violation THEN
            -- Atualizar a assinatura existente
            UPDATE subscription
            SET start_date = p_start_date, end_date = p_end_date
            WHERE user_id = p_user_id AND discount_id = p_discount_id;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar ou atualizar assinatura: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Subscription_READ(
    p_user_id INTEGER,
    p_discount_id INTEGER
)
RETURNS TABLE(subscription_id INTEGER, user_id INTEGER, discount_id INTEGER, start_date TIMESTAMP, end_date TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.subscription_id,
        s.user_id,
        s.discount_id,
        s.start_date,
        s.end_date
    FROM subscription s
    WHERE s.user_id = p_user_id AND s.discount_id = p_discount_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_Subscription_UPDATE(
    p_user_id INTEGER,
    p_discount_id INTEGER,
    p_new_start_date TIMESTAMP,
    p_new_end_date TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE subscription
        SET start_date = p_new_start_date, end_date = p_new_end_date
        WHERE user_id = p_user_id AND discount_id = p_discount_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar assinatura: %', SQLERRM;
    END;
END $$ LANGUAGE plpgsql;
