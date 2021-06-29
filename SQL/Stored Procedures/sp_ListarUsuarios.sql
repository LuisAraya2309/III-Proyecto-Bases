USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarUsuarios
--Devuelve la lista de todos los usuarios ordenados alfabéticamente
AS
BEGIN
	-- Codigo para probar el SP

    --EXEC dbo.sp_ListarUsuarios

	SET NOCOUNT ON;

	SELECT 
		* 
	FROM dbo.Usuarios AS U
	WHERE 
		U.activo = 1
	ORDER BY U.username

	SET NOCOUNT OFF;

END
GO