CREATE TRIGGER Tr_SemanaPlanillaDeduccion 
ON dbo.Empleados
AFTER INSERT 
AS
	DECLARE @idEmpleado INT = (SELECT Id FROM inserted); 
	DECLARE @fechaInicioDeduccion DATE = (SELECT FechaInicio FROM SemanaPlanilla WHERE Id = (SELECT MAX(Id) FROM SemanaPlanilla) );

	INSERT INTO dbo.DeduccionXEmpleado (FechaInicio,IdEmpleado,IdTipoDeduccion)
			SELECT 
				@fechaInicioDeduccion , 
				I.Id,
				T.Id
				FROM inserted I INNER JOIN TipoDeduccion T
				ON T.EsObligatoria = 'Si'
			
	INSERT INTO dbo.PlanillaXMesxEmpleado
		(
		SalarioBruto,
		SalarioNeto,
		IdEmpleado,
		IdMesPlanilla
		)
		VALUES
		(
			0.0,
			0.0,
			(SELECT I.Id  FROM inserted I),
			(SELECT MAX(MP.Id) AS ID FROM dbo.MesPlanilla AS MP)
		)

	INSERT INTO dbo.PlanillaXSemanaxEmpleado
		(
		SalarioBruto,
		SalarioNeto,
		IdEmpleado,
		IdSemanaPlanilla,
		IdPlanillaXMesXEmpleado
		)
		VALUES
		(
			0.0,
			0.0,
			(SELECT I.Id  FROM inserted I),
			(SELECT MAX(SP.Id) AS ID FROM dbo.SemanaPlanilla AS SP),
			(SELECT MAX(MP.Id) AS ID FROM dbo.PlanillaXMesxEmpleado AS MP)
		)

