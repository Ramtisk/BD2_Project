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
    IF NEW.discount_id IS DISTINCT FROM 1 THEN
        UPDATE SUBSCRIPTION
        SET DISCOUNT_ID = 1
        WHERE SUBSCRIPTION_ID = NEW.SUBSCRIPTION_ID and DISCOUNT_ID = null ;
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

