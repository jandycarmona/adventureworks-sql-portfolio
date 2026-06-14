/* =============================================================================
   High-value reseller orders for a Q4 2013 audit
   -----------------------------------------------------------------------------
   Business problem:
     Finance is auditing the largest reseller (non-online) sales from the last
     quarter of 2013. They need every reseller order placed in that quarter with
     a total due above 20,000 for manual review, ordered by amount.

   Approach:
     - Reseller orders only: OnlineOrderFlag = 0 excludes online (direct
       customer) sales, which belong to a different channel.
     - The Q4 2013 window is expressed as a half-open interval:
       OrderDate >= '20131001' AND OrderDate < '20140101'. OrderDate is a
       datetime, so an inclusive upper bound like <= '20131231' would drop any
       order placed on Dec 31 with a time component after midnight. The exclusive
       '20140101' bound covers the whole last day regardless of time.
     - The literals use the 'YYYYMMDD' format (no separators), which SQL Server
       interprets independently of the session's language / DATEFORMAT settings.
     - TotalDue > 20000 keeps only the high-value orders the audit targets.
     - Results are ordered from the highest total to the lowest.

   Tables:
     Sales.SalesOrderHeader

   Concepts: SELECT, WHERE, BIT filter, date-range filtering (half-open
             interval), comparison operators, ORDER BY
   ============================================================================= */

SELECT
	SalesOrderNumber,
	OrderDate,
	CustomerID,
	TotalDue
FROM
	Sales.SalesOrderHeader
WHERE
	OnlineOrderFlag = 0
	AND TotalDue > 20000
	AND OrderDate >= '20131001'
	AND OrderDate < '20140101'
ORDER BY
	TotalDue DESC