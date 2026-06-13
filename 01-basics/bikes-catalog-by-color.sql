/* =============================================================================
   Bikes catalog by color
   -----------------------------------------------------------------------------
   Business problem:
     Marketing wants a quick fact sheet of the bicycles currently on sale,
     grouped by color, to decide which variants to feature in a campaign.

   Approach:
     - Only bicycle subcategories are included. The pattern LIKE '%Bikes' anchors
       the match to names ending in "Bikes" (Mountain Bikes, Road Bikes, Touring
       Bikes). This deliberately excludes accessory subcategories that also begin
       with "Bike" but end differently (Bike Racks, Bike Stands).
     - A product is "sellable" when its list price is greater than 0 and it has
       no sell-end date (SellEndDate IS NULL).
     - Products with no color (Color IS NULL) are excluded, since a color is
       required for the campaign fact sheet.
     - Results are ordered by color (alphabetically) and, within each color, from
       the most to the least expensive.

   Tables:
     Production.Product, Production.ProductSubcategory

   Concepts: SELECT, WHERE, LIKE (anchored pattern), NULL handling, INNER JOIN,
             ORDER BY (multiple keys)
   ============================================================================= */

SELECT 
	Product = P.Name,
	P.Color,
	P.Size,
	P.ListPrice
FROM 
	Production.Product P
	INNER JOIN Production.ProductSubcategory S ON P.ProductSubcategoryID = S.ProductSubcategoryID
WHERE
	S.Name LIKE '%Bikes'
	AND P.ListPrice > 0
	AND P.SellEndDate IS NULL
	AND P.Color IS NOT NULL
ORDER BY
	P.Color,
	P.ListPrice DESC
