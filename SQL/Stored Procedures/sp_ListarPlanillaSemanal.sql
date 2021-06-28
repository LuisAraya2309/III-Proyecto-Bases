USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_ListarPlanillaSemanal
    @inValorDocIdentidad INT,
    @OutResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @OutResultCode = 0

        IF NOT EXISTS (SELECT 1 FROM dbo.Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad)
			BEGIN
				SET @OutResultCode = 5001 
				RETURN
			END

		DECLARE @idEmpleado INT = (SELECT E.Id FROM dbo.Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad), @iteradorPlanillaXSemanaXEmpleado INT,
		@IdPlanillaXSemanaXEmpleado INT;

		DECLARE @Horas TABLE (Horas INT);
		DECLARE @HorasExtras TABLE(Horas INT);
		DECLARE @HorasExtraDobles TABLE(Horas INT);
		DECLARE @UltimasPlanillas TABLE (Id INT);

		INSERT INTO @UltimasPlanillas
			SELECT TOP(15) 
				PSE.id 
			FROM PlanillaXSemanaxEmpleado AS PSE 
			WHERE PSE.IdEmpleado = @idEmpleado 
			ORDER BY (Id)DESC

		SELECT @iteradorPlanillaXSemanaXEmpleado = COUNT(*) FROM @UltimasPlanillas

		WHILE @iteradorPlanillaXSemanaXEmpleado < 0
			
			SET @IdPlanillaXSemanaXEmpleado = (SELECT TOP (1) H.Horas FROM @Horas AS H)

			--Calcular la cantidad de horas ordinarias
			INSERT INTO @Horas
				SELECT Horas FROM MovimientoDeHoras AS MH 
				INNER JOIN MovimientoPlanilla AS MP 
				ON MP.Id = MH.Id 
				WHERE MP.IdPlanillaXSemanaXEmpleado = @IdPlanillaXSemanaXEmpleado AND MP.IdTipoMovimientoPlanilla = 1 
			
			--Calcular la cantidad de horas extras
			INSERT INTO @HorasExtras
				SELECT Horas FROM MovimientoDeHoras AS MH 
				INNER JOIN MovimientoPlanilla AS MP 
				ON MP.Id = MH.Id 
				WHERE MP.IdPlanillaXSemanaXEmpleado = @IdPlanillaXSemanaXEmpleado AND MP.IdTipoMovimientoPlanilla = 2 

			--Calcular la cantidad de horas extras dobles
			INSERT INTO @HorasExtraDobles
				SELECT Horas FROM MovimientoDeHoras AS MH 
				INNER JOIN MovimientoPlanilla AS MP 
				ON MP.Id = MH.Id 
				WHERE MP.IdPlanillaXSemanaXEmpleado = @IdPlanillaXSemanaXEmpleado AND MP.IdTipoMovimientoPlanilla = 3 

			SELECT 
				PSE.Id,
				PSE.SalarioBruto,
				PSE.SalarioNeto,
				PSE.SalarioBruto - PSE.SalarioNeto AS TotalDeducciones,
				(SELECT SUM(Horas) FROM @Horas),
				(SELECT SUM(Horas) FROM @HorasExtras),
				(SELECT SUM(Horas) FROM @HorasExtraDobles)

			FROM PlanillaXSemanaXEmpleado AS PSE
			WHERE PSE.Id = @IdPlanillaXSemanaXEmpleado

			DELETE TOP(1) FROM @UltimasPlanillas
			SELECT @iteradorPlanillaXSemanaXEmpleado = COUNT(*) FROM @UltimasPlanillas
			DELETE FROM @Horas
			DELETE FROM @HorasExtras
			DELETE FROM @HorasExtraDobles

    END TRY
    BEGIN CATCH
        IF @@Trancount>0 
            ROLLBACK TRANSACTION Modificacion;

        INSERT INTO dbo.Errores VALUES(
            SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
        )

        SET @OutResultCode = 501;

    END CATCH

    SET NOCOUNT OFF

END