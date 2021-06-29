USE[SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarPuestos
--PRIMERA FUNCIONALIDAD: Devuelve la lista de todos los puestos ordenados alfabéticamente
AS
BEGIN
	-- Codigo para probar el SP

    --EXEC dbo.sp_ListarPuesto 

	SET NOCOUNT ON;

	SELECT 
		* 
	FROM dbo.Puestos AS P
	WHERE 
		P.activo = 1
	ORDER BY P.Nombre

	SET NOCOUNT OFF;

END
GO


