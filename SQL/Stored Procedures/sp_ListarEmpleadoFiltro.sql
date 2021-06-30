USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarEmpleadosFiltro 
	@inFiltro varchar(40)

--Devuelve la lista de todos los empleados ordenados por un filtro
AS
BEGIN
	-- Codigo para probar el SP

    --EXEC dbo.sp_ListarEmpleadosFiltro "V" ;
	SET NOCOUNT ON;

	SELECT 
		*
	FROM dbo.Empleados AS E
	WHERE 
		E.Nombre LIKE @inFiltro
		AND E.Activo = 1
	ORDER BY E.Nombre;

	SET NOCOUNT OFF;

END
GO
