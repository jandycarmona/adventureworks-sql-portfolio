/* =============================================================================
   Mid-priced accessories and clothing catalog
   -----------------------------------------------------------------------------
   Business problem:
     Merchandising is reviewing the mid-priced catalog and wants to see how
     products in the Accessories and Clothing lines distribute across a specific
     price band, in order to plan a store section.

   Approach:
     - The product hierarchy is traversed with two INNER JOINs:
       Product -> ProductSubcategory -> ProductCategory, so each product is shown
       together with its subcategory and its category.
     - Only the Accessories and Clothing categories are kept, filtered by category
       name with IN.
     - A product is "sellable" when it has no sell-end date (SellEndDate IS NULL).
       The "list price > 0" rule is implied here: the BETWEEN 20 AND 100 band
       already guarantees a positive price, so an explicit > 0 would be redundant.
     - ListPrice BETWEEN 20 AND 100 keeps the mid-priced band. BETWEEN is safe on
       a numeric column because, unlike a datetime, there is no hidden time
       component that could make the inclusive upper bound silently drop rows.
     - All three tables expose a Name column, so every output column is qualified
       and aliased to avoid ambiguity.
     - Results are ordered by category, then subcategory, then price descending.

   Tables:
     Production.Product, Production.ProductSubcategory, Production.ProductCategory

   Concepts: SELECT, aliases, multiple INNER JOIN (3-level hierarchy), IN,
             BETWEEN, ORDER BY (multiple keys)
   ============================================================================= */

SELECT 
	Product     = A.Name,
	SubCategory = B.Name,
	Category    = C.Name,
	Price       = A.ListPrice
FROM
	Production.Product A
	INNER JOIN Production.ProductSubcategory B ON A.ProductSubcategoryID = B.ProductSubcategoryID
	INNER JOIN Production.ProductCategory C ON B.ProductCategoryID = C.ProductCategoryID
WHERE 
	C.Name IN ('Accessories', 'Clothing')
	AND A.SellEndDate IS NULL
	AND A.ListPrice BETWEEN 20 AND 100
ORDER BY
	Category,
	SubCategory,
	Price DESC
