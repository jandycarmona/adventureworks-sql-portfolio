/* =============================================================================
   Salesperson scorecard by territory
   -----------------------------------------------------------------------------
   Business problem:
     The sales team wants a performance scorecard for its quota-carrying reps in
     the North America and Europe territory groups. For each rep they need order
     volume, total billings, a performance tier, and a quick flag for whether the
     rep has ever sold a product from the bike line.

   Approach:
     - Only reps with an active quota are kept (SalesQuota IS NOT NULL), and only
       those whose territory group is North America or Europe, filtered on the
       Group column with IN. Group is a reserved word, hence the bracketed
       [Group].
     - The grain is one row per salesperson. Grouping is done on BusinessEntityID
       (the primary key, so two reps sharing a name are never merged) while the
       descriptive columns are carried along for display.
     - A LEFT JOIN to SalesOrderHeader keeps reps with no orders: COUNT counts a
       non-null key (SalesOrderID), so those reps correctly show 0 rather than 1.
     - VentasTotales sums TotalDue (final amount, taxes and freight included),
       matching the figure used elsewhere in the repo for sales value.
     - The performance tier is computed with CASE over the summed billings; an
       explicit ELSE 'Bronze' guarantees no rep is left with a NULL tier.
     - VendioBicicletas is a correlated EXISTS. It is intentionally correlated on
       the SALESPERSON (SalesPersonID = the outer rep), not on a single order:
       the flag is a property of the rep across all their orders. Correlating on
       the order grain would force SalesOrderID into the GROUP BY and explode the
       result back to one row per order. The bike line is matched with
       LIKE '%Bikes' (end-anchored) to exclude bike accessory subcategories.
     - HAVING filters on the aggregate (total billings above 50,000), which is
       why it lives in HAVING and not in WHERE.

   Tables:
     Sales.SalesPerson, Sales.SalesTerritory, Person.Person,
     Sales.SalesOrderHeader, Sales.SalesOrderDetail, Production.Product,
     Production.ProductSubcategory

   Concepts: INNER JOIN, LEFT JOIN, aggregate functions, GROUP BY (on PK),
             HAVING, CASE, IN, IS NOT NULL, correlated EXISTS, LIKE (anchored)
   ============================================================================= */

SELECT
	FullName          = CONCAT_WS(' ', C.FirstName, ISNULL(C.MiddleName, ''), C.LastName),
	AssignedTerritory = B.Name,
	TerritoryGroup    = B.[Group],
	OrderCount        = COUNT(D.SalesOrderID),
	TotalSales        = SUM(D.TotalDue),
	PerformanceTier   = CASE
							WHEN SUM(D.TotalDue) BETWEEN 100000 AND 1000000   THEN 'Silver'
							WHEN SUM(D.TotalDue) BETWEEN 1000001 AND 10000000 THEN 'Gold'
							WHEN SUM(D.TotalDue) > 10000000                   THEN 'Platinum'
							ELSE 'Bronze'
						 END,
	SoldBikes         = IIF(
							EXISTS(
								SELECT
									1
								FROM
									Sales.SalesOrderHeader W
									INNER JOIN Sales.SalesOrderDetail X ON W.SalesOrderID = X.SalesOrderID
									INNER JOIN Production.Product Y ON X.ProductID = Y.ProductID
									INNER JOIN Production.ProductSubcategory Z ON Z.ProductSubcategoryID = Y.ProductSubcategoryID
								WHERE
									W.SalesPersonID = A.BusinessEntityID
									AND Z.Name LIKE '%Bikes'),
							'Yes', 'No')
FROM
	Sales.SalesPerson A
	INNER JOIN Sales.SalesTerritory B ON A.TerritoryID = B.TerritoryID
	INNER JOIN Person.Person C ON A.BusinessEntityID = C.BusinessEntityID
	LEFT JOIN Sales.SalesOrderHeader D ON A.BusinessEntityID = D.SalesPersonID
WHERE
	A.SalesQuota IS NOT NULL
	AND B.[Group] IN ('North America', 'Europe')
GROUP BY
	A.BusinessEntityID,
	C.FirstName,
	C.MiddleName,
	C.LastName,
	B.Name,
	B.[Group]
HAVING
	SUM(D.TotalDue) > 50000
ORDER BY
	TotalSales DESC