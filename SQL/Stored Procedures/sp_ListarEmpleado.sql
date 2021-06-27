USE SistemaObrero
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
		E.Nombre
		, E.fechaNacimiento
		, T.nombre
		, E.ValorDocumentoIdentidad
		, P.Nombre
		, D.nombre
	FROM dbo.Empleados AS E
	--El inner join esta siendo utilizado para encontrar el atributo de una tabla basado en el id que relaciona dicha tabla con Empleado
	INNER JOIN dbo.Puestos AS P ON  E.IdPuesto =  P.Id
	INNER JOIN dbo.TipoDocIdentidad AS T ON  E.ValorDocumentoIdentidad =  T.Id
	INNER JOIN dbo.Departamento AS D ON  E.idDepartamento = D.id
	WHERE 
		E.activo = 1
		AND P.activo = 1
	ORDER BY E.Nombre;

	SET NOCOUNT OFF;

END
GO
