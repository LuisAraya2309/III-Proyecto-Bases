USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarEmpleados
--Devuelve la lista de todos los empleados ordenados alfabéticamente
AS
BEGIN
	-- Codigo para probar el SP

    --EXEC dbo.sp_ListarEmpleados
	SET NOCOUNT ON;

	SELECT 
		*
	FROM dbo.Empleados AS E
	WHERE 
		E.Activo = 1
	ORDER BY E.Nombre;

	SET NOCOUNT OFF;

END
GO
