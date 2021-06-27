USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarDeduccionXEmpleado @inIdEmpleado INT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		DE.Id,
		DE.FechaInicio,
		(SELECT TD.Nombre FROM TipoDeduccion AS TD WHERE TD.Id = DE.IdTipoDeduccion),
		(SELECT FNO.Monto FROM FijaNoObligatoria AS FNO WHERE DE.Id = FNO.Id),
		(SELECT NOP.Porcentage FROM DeduccionXEmpleadoNoObligatoriaPorcentual AS NOP WHERE DE.Id = NOP.Id)

	FROM dbo.DeduccionXEmpleado AS DE
	WHERE
		IdEmpleado = @inIdEmpleado AND
		DE.FechaFin = NULL 

	SET NOCOUNT OFF;

END
GO