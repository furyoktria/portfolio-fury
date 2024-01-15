SELECT Product.product_name, Sales.year, Sales.price
FROM Sales
RIGHT JOIN Product
ON Product.product_id = Sales.product_id
WHERE Sales.year IS NOT NULL
AND Sales.price IS NOT NULL
ORDER BY sales.year ASC;