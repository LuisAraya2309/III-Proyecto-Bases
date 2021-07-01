CREATE FUNCTION [dbo].[CalcularSalarioNeto]( 
    @salarioBruto INT,
    @Totaldeducciones INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT

    SELECT @Total = @salarioBruto - @Totaldeducciones

    RETURN @Total

END