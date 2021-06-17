

CREATE TRIGGER Tr_SemanaPlanillaDeduccion 
ON dbo.Empleados
FOR INSERT 
AS
	DECLARE @idEmpleado INT = (SELECT Id FROM inserted); 
	DECLARE @fechaInicioDeduccion DATE = (SELECT FechaInicio FROM SemanaPlanilla WHERE Id = (SELECT MAX(Id) FROM SemanaPlanilla) );
	INSERT INTO DeduccionXEmpleado (FechaInicio,IdEmpleado,IdTipoDeduccion)
			SELECT @fechaInicioDeduccion,@idEmpleado,Id FROM TipoDeduccion WHERE EsObligatoria = 'Si';
			

			
	INSERT INTO PlanillaXMesxEmpleado
		VALUES
		(
			0,
			0,
			(SELECT MAX(Id) AS ID FROM dbo.MesPlanilla)
		)

	INSERT INTO PlanillaXSemanaxEmpleado
		VALUES
		(
			0,
			0,
			(SELECT Id  FROM inserted),
			(SELECT MAX(Id) AS ID FROM dbo.SemanaPlanilla),
			(SELECT MAX(Id) AS ID FROM dbo.MesPlanilla)

		)

--DROP TRIGGER Tr_SemanaPlanillaDeduccion 