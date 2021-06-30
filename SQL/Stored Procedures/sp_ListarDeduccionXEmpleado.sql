USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarDeduccionXEmpleado @inValorDocIdentidad INT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		DE.Id,
		DE.FechaInicio,
		(SELECT TD.Nombre FROM TipoDeduccion AS TD WHERE TD.Id = DE.IdTipoDeduccion) AS NombreTipoDedu,
		(SELECT FNO.Monto FROM FijaNoObligatoria AS FNO WHERE DE.Id = FNO.Id) AS MontoFijaNoO,
		(SELECT NOP.Porcentage FROM DeduccionXEmpleadoNoObligatoriaPorcentual AS NOP WHERE DE.Id = NOP.Id) AS PorcentajeNoObligatoria

	FROM dbo.DeduccionXEmpleado AS DE
	WHERE
		IdEmpleado = (SELECT E.Id FROM Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad) AND
		DE.FechaFin IS NULL 

	SET NOCOUNT OFF;

END
GO
