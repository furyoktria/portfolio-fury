--Drop or Hardly Remove Table from Database
DROP TABLE transactions;

--Ensure Table is well initialize
DESCRIBE TABLE transactions;

--Get all of data in one place
SELECT * FROM transactions;

--Table Creation
CREATE TABLE transactions (
    Id INT AUTO_INCREMENT,
    customer_id INT,
    order_id VARCHAR(16),
    transaction_date TIMESTAMP, 
    status VARCHAR(16),
    vendor VARCHAR(8),
    PRIMARY KEY (Id, customer_id)
);

--Inserting Data on the Table
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('422818', 'TEST000001','2018-01-01 00:00:10','SHIPPED', 'Vendor A');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('181820', 'TEST000002', '2018-01-01 00:10:10', 'SHIPPED', 'Vendor A');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('999019', 'TEST000003', '2018-01-02 03:18:01', 'CANCELLED', 'Vendor A');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('1923192', 'TEST000004','2018-02-04 05:00:00', 'CANCELLED','Vendor C');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('645532', 'TEST000005','2018-02-10 16:00:10', 'SHIPPED', 'Vendor C');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('1101011', 'TEST000006', '2018-02-11 11:00:11', 'SHIPPED', 'Vendor C');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('1020000', 'TEST000007', '2018-02-10 00:00:00', 'SHIPPED', 'Vendor D');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('40111234', 'TEST000008', '2018-03-11 06:30:11', 'SHIPPED', 'Vendor D');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('1923192', 'TEST000009', '2018-03-12 10:00:11', 'CANCELLED', 'Vendor B');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('1101011', 'TEST000010', '2018-03-12 15:30:12', 'SHIPPED', 'Vendor B');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('999019', 'TEST000011', '2018-03-15 12:30:45', 'CANCELLED', 'Vendor A');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('645532', 'TEST000012', '2018-04-01 09:30:22', 'SHIPPED', 'Vendor A');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('650013', 'TEST000013', '2018-04-01 10:50:37', 'SHIPPED', 'Vendor C');
INSERT INTO transactions (customer_id, order_id, transaction_date, status, vendor) VALUES ('777734', 'TEST000014', '2018-04-02 13:45:19', 'SHIPPED', 'Vendor D');

--PART 1

---1_Show list of transactions occurring in February 2018 with SHIPPED status.
-----Option A
SELECT *
FROM transactions
WHERE transaction_date LIKE '_____02%' AND status = 'SHIPPED';

-----Option B
SELECT *
FROM transactions
WHERE transaction_date 
BETWEEN '2018-01-31 23:59:59' 
AND '2018-03-01 00:00:00'
AND status = 'SHIPPED';

---2_Show list of transactions occurring from midnight to 9 AM
SELECT *
FROM transactions
WHERE HOUR(transaction_date) < '9';

---3_Show a list of only the last transactions from each vendor
SELECT MAX (transaction_date) AS latest_transaction_time, vendor
FROM transactions
GROUP BY vendor
ORDER BY vendor ASC;

---4_Show a list of only the second last transactions from each vendor
-----Option A
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY vendor ORDER BY transaction_date DESC) AS rownumber
    FROM transactions
 ) transactions 
WHERE rownumber = 2;

-----Option B
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY vendor ORDER BY transaction_date DESC) AS rownumber
    FROM transactions
 ) transactions 
WHERE rownumber = 2;

---5_Count the transactions from each vendor with the status CANCELLED per day
SELECT transactions.vendor, COUNT (status) AS status_is_cancelled
FROM transactions
WHERE status = 'cancelled'
GROUP BY vendor;

---6_Show a list of customers who made more than 1 SHIPPED purchases
SELECT *
FROM
(SELECT customer_id, COUNT(status) AS number_of_shipped
FROM transactions 
WHERE status = 'shipped'
GROUP BY customer_id) AS transaction_2
WHERE number_of_shipped > 1;

---7_Show the total transactions (volume) and category of each vendors by following these criteria: 
---a. Superb: More than 2 SHIPPED and 0 CANCELLED transactions
---b. Good: More than 2 SHIPPED and 1 or more CANCELLED transactions
---c. Normal: other than Superb and Good criteria
---Order the vendors by the best category (Superb, Good, Normal), then by the biggest transaction volume

SELECT vendor, category, total_transactions
FROM (
    SELECT vendor,
           COUNT(*) AS total_transactions,
           CASE
               WHEN COUNT(*) > 2 AND SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) = 0 THEN 'Superb'
               WHEN COUNT(*) > 2 AND SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) > 0 THEN 'Good'
               ELSE 'Normal'
           END AS category
    FROM transactions
    GROUP BY vendor
) AS tekowek
ORDER BY category DESC, total_transactions DESC;

SELECT *
From transactions;

--8_Group the transactions by hour of transaction_date--
SELECT HOUR (transaction_date) AS Hour_of_the_day, COUNT (order_id) AS Total_Transaction
FROM transactions
GROUP BY hour_of_the_day
ORDER BY hour_of_the_day ASC;

--9_Group the transactions by day and statuses as the example below
SELECT DATE (transaction_date) AS Date, 
        SUM (CASE WHEN status= 'shipped' THEN 1 ELSE 0 END) AS Shipped,
        SUM (CASE WHEN status= 'cancelled' THEN 1 ELSE 0 END) AS Cancelled,
        SUM (CASE WHEN status = 'processing' THEN 1 ELSE 0 END) AS Processing
From transactions
Group by DATE
ORDER by DATE ASC;

--10_Calculate the average, minimum and maximum of days interval of each transaction (how many days from one transaction to the next)
WITH    table_1 AS (SELECT (transaction_date) AS transaction_date_1,
        LEAD(transaction_date) OVER(ORDER BY transaction_date) AS PREVIOUS_DATE
FROM transactions
ORDER BY transaction_date_1 ASC)

SELECT  AVG(TIMESTAMPDIFF(DAY,transaction_date_1,PREVIOUS_DATE)) AS Average_Interval, 
        MAX(TIMESTAMPDIFF(DAY,transaction_date_1,PREVIOUS_DATE)) AS Maximum_Interval, 
        MIN(TIMESTAMPDIFF(DAY,transaction_date_1,PREVIOUS_DATE)) AS Minimum_Interval
FROM table_1
WHERE PREVIOUS_DATE IS NOT NULL;


--Jika mau tahu interval
WITH    table_1 AS (SELECT (transaction_date) AS transaction_date_1,
        LEAD(transaction_date) OVER(ORDER BY transaction_date) AS PREVIOUS_DATE
FROM transactions
ORDER BY transaction_date_1 ASC)

SELECT  TIMESTAMPDIFF(DAY,transaction_date_1,PREVIOUS_DATE) AS 'INTERVAL'
FROM table_1
WHERE PREVIOUS_DATE IS NOT NULL;








































