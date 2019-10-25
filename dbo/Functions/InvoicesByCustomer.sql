

CREATE FUNCTION [dbo].[InvoicesByCustomer](@CustID int)
RETURNS @CustomerInvoices TABLE 
(
    -- columns returned by the function
    CustId int NOT NULL,
	OrderId INT NOT NULL,
    CustName nvarchar(255) NOT NULL
)
AS
-- body of the function
BEGIN
   WITH CustomerInvoices(CustId, OrdId, CustName) AS
    (SELECT CustomerID, OrderId, N'ThisIsMyCustomer'
	FROM Sales.Invoices
	WHERE CustomerID = @CustID
    )
   -- copy the required columns to the result of the function 

   INSERT @CustomerInvoices
   SELECT CustId, OrdId, CustName
     FROM CustomerInvoices 
	 ORDER BY OrdId 
   RETURN
END
