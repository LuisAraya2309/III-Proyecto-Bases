
CREATE TRIGGER Tr_SemanaPlanillaDeduccion 
ON dbo.Empleados
FOR INSERT 
AS

EXEC sp_AsoDeduCreaPlanillaMesSemana 0

--DROP TRIGGER Tr_SemanaPlanillaDeduccion 