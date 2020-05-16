# В таблице products есть два текстовых поля:
  # name с названием товара и description с его описанием.
  # Допустимо присутствие обоих полей или одно из них.
  # Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
  # Используя триггеры, добейтесь того,
  # чтобы одно из этих полей или оба поля были заполнены.
  # При попытке присвоить полям NULL-значение необходимо отменить операцию.

CREATE TRIGGER products_insert BEFORE INSERT ON products
  FOR EACH ROW
BEGIN
  if NEW.name = '' and NEW.desription_my = '' then
    signal sqlstate '45000';
  end if;
END;

INSERT INTO products
(name, desription_my, price, catalog_id)
VALUES
('ts', '', 7890.00, 1);
INSERT INTO products
(name, desription_my, price, catalog_id)
VALUES
('', 'test', 7890.00, 1);
INSERT INTO products
(name, desription_my, price, catalog_id)
VALUES
('', '', 7890.00, 1);

SELECT * FROM products;
DROP TRIGGER products_insert;