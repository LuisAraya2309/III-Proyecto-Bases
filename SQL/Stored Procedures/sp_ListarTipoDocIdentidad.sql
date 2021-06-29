USE [SistemaObrero]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.sp_ListarTipoDocIdentidad
AS
BEGIN
	-- Codigo para probar el SP

    --EXEC dbo.sp_ListarTipoDocIdentidad 
	SET NOCOUNT ON;

    SELECT 
		*
	FROM dbo.TipoDocIdentidad AS T
	WHERE 
		T.activo = 1
    ORDER BY T.Nombre

	SET NOCOUNT OFF;

END
GO

