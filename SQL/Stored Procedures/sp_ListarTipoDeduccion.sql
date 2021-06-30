USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarTipoDeduccion
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		TD.Id,
		TD.Nombre,
		TD.EsPorcentual,
		TD.EsObligatoria

	FROM dbo.TipoDeduccion AS TD
	ORDER BY TD.Nombre;

	SET NOCOUNT OFF;

END
GO
