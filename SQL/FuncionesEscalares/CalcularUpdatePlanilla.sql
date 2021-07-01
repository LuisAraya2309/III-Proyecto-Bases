CREATE FUNCTION [dbo].[CalcularUpdatePlanilla]( 
    @sumaActual INT,
    @horasOrdinarias INT,
    @horasExtras INT,
    @horasDobles INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT

    SELECT @Total = @sumaActual + @horasOrdinarias + @horasExtras + @horasDobles

    RETURN @Total

END