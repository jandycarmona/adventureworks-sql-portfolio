/* =============================================================================
   Premium products by subcategory
   -----------------------------------------------------------------------------
   Business problem:
     The sales team wants to build a high-end catalog. It needs the 15 most
     expensive sellable products, along with their subcategory, to see which
     product lines concentrate premium pricing.

   Approach:
     - A product is considered "sellable" when its list price is greater than 0
       and it has no sell-end date (SellEndDate IS NULL).
     - The price including VAT (18%) is computed, rounded to 2 decimals.
     - An INNER JOIN to ProductSubcategory is used: this intentionally excludes
       products without a subcategory (raw materials and components whose
       ProductSubcategoryID is NULL), which are not part of a sales catalog.
     - TOP 15 WITH TIES is used: if the cutoff price repeats (common across
       size/color variants of the same bike), all tied rows are included. The
       business criterion is price, so the row count may exceed 15 without
       breaking the intent.

   Tables:
     Production.Product, Production.ProductSubcategory

   Concepts: SELECT, computed column, WHERE, INNER JOIN, TOP ... WITH TIES,
             ORDER BY
   ============================================================================= */

SELECT TOP 15 WITH TIES
    Product      = A.Name,
    Subcategory  = B.Name,
    Price        = A.ListPrice,
    PriceWithVAT = CAST(A.ListPrice * 1.18 AS DECIMAL(10, 2))
FROM
    Production.Product A
    INNER JOIN Production.ProductSubcategory B ON A.ProductSubcategoryID = B.ProductSubcategoryID
WHERE
    A.ListPrice > 0
    AND A.SellEndDate IS NULL
ORDER BY
    A.ListPrice DESC;
