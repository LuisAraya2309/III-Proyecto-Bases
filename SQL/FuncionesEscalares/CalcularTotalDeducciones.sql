CREATE FUNCTION [dbo].[CalcularTotalDeducciones]( 
    @montoDeducciones INT,
    @nuevaDeduccion INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT

    SELECT @Total = @montoDeducciones + @nuevaDeduccion

    RETURN @Total

END