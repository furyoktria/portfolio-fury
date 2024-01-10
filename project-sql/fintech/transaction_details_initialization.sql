--Drop or Hardly Remove Table from Database
DROP TABLE transaction_details;

--Ensure Table is well initialize
DESCRIBE TABLE transaction_details;

--Get all of data in one place
SELECT * FROM transaction_details;

--Table Creation
CREATE TABLE transaction_details (
    Id	INT,
    trx_id	INT,
    product_name	VARCHAR(512),
    quantity	INT,
    price 	INT,
    PRIMARY KEY (Id)
);

ALTER TABLE transaction_details
ADD FOREIGN KEY (trx_id)
REFERENCES transactions(Id)
ON DELETE SET NULL;

INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('1', '1', 'Beng beng', '100', '6000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('2', '1', 'Taro', '80', '5500 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('3', '2', 'Beng beng', '70', '6000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('4', '2', 'Taro', '41', '5500 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('5', '2', 'Indomie Kari Ayam', '12', '3000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('6', '2', 'Indomie Ayam Bawang', '20', '3100 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('7', '3', 'Indomie Ayam Bawang', '30', '3200 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('8', '3', 'Indomie Kari Ayam', '90', '3300 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('9', '3', 'Taro', '100', '5500 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('10', '4', 'Beng beng', '40', '6000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('11', '5', 'Teh Sariwangi Murni', '50', '8000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('12', '6', 'Indomie Kari Ayam', '10', '3000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('13', '6', 'Indomie Ayam Bawang', '8', '3100 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('14', '6', 'Teh Sariwangi Murni', '80', '8000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('15', '6', 'The Hijau Cap Kepala Djenggot', '15', '9500 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('16', '7', 'Coki-coki', '70', '1000 ');
INSERT INTO transaction_details (Id, trx_id, product_name, quantity, price ) VALUES ('17', '8', 'Bakmi Mewah', '1500', '13000');


--1_Show the sum of the total value of the products shipped along with the Distributor 
--Commissions (2% of the total product value if total quantity is 100 or less, 
--4% of the total product value if total quantity sold is more than 100)

SELECT  product_name AS 'Product Name', 
        SUM(price*quantity) AS 'Value (Quantity x Price)', 
        CASE
               WHEN SUM (quantity) > 100 
               THEN SUM(price*quantity*0.4) 
               ELSE SUM(price*quantity*0.2)
        END AS 'Distributor Commissions'
FROM transaction_details
GROUP BY product_name;

--2_Show total quantity of "Indomie (all variant)" shipped within February 2018
SELECT *
FROM transaction_details
JOIN transactions
WHERE transactions.id = transaction_details.trx_id 
    AND status = 'shipped' 
    AND product_name LIKE "Indomie%"
    AND transaction_date 
    BETWEEN '2018-01-31 23:59:59' 
    AND '2018-03-01 00:00:00';

--3_For each product, show the ID of the last transaction which contained that particular product
SELECT  transaction_details.product_name AS 'Product Name', 
        MAX (transaction_details.trx_id) AS 'Last Transaction ID'
FROM transaction_details
GROUP BY transaction_details.product_name
ORDER BY transaction_details.product_name ASC;
