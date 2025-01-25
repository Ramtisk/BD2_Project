CREATE OR REPLACE FUNCTION generate_boleto_on_plan_subscription()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO PAYMENT (PAYMENT_ID, SUBSCRIPTION_ID, USER_ID, AMOUNT, DATE)
    VALUES (NEXTVAL('payment_payment_id_seq'), NEW.SUBSCRIPTION_ID, 
            (SELECT USER_ID FROM SUBSCRIPTION WHERE SUBSCRIPTION_ID = NEW.SUBSCRIPTION_ID), 
            (SELECT PRICE FROM PLAN WHERE PLAN_ID = NEW.PLAN_ID), NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER boleto_on_plan_subscription_trigger
AFTER INSERT ON PLAN_SUBSCRIPTION
FOR EACH ROW
EXECUTE FUNCTION generate_boleto_on_plan_subscription();

----------------------------------------------------------------

SELECT subscription_id, start_date, end_date, discount_id, user_id
	FROM public.subscription;

CREATE OR REPLACE FUNCTION apply_loyalty_discount()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar se é uma renovação (end_date antigo é menor que start_date novo)
    IF OLD.end_date < NEW.start_date THEN
        -- Aplicar desconto de fidelidade apenas se não houver desconto atual
        IF NEW.discount_id IS NULL THEN
            NEW.discount_id := 1;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Criar o Trigger
CREATE TRIGGER loyalty_discount_trigger
AFTER UPDATE ON SUBSCRIPTION
FOR EACH ROW
EXECUTE FUNCTION apply_loyalty_discount();
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_subscription_dates() 
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se end_date é anterior a start_date
    IF NEW.end_date < NEW.start_date THEN
        RAISE EXCEPTION 'A data de término não pode ser anterior à data de início';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER subscription_date_check
BEFORE INSERT OR UPDATE ON subscription
FOR EACH ROW
EXECUTE FUNCTION check_subscription_dates();
