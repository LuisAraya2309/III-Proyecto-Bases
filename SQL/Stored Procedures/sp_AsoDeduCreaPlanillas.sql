USE SistemaObrero
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_AsoDeduCreaPlanillaMesSemana @outResultCode INT OUTPUT
	
AS
BEGIN
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
			(SELECT MAX(Id) AS ID FROM dbo.Empleados),
			(SELECT MAX(Id) AS ID FROM dbo.SemanaPlanilla),
			(SELECT MAX(Id) AS ID FROM dbo.MesPlanilla)

		)
END
GO
