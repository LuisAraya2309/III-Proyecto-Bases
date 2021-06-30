
USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_MarcaAsistenciaPlanilla
    @inIdPlanillaXSemanaXEmpleado INT,
    @OutResultCode INT OUTPUT

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
			SET @OutResultCode = 0
			SELECT DISTINCT
					MA.Id AS MarcaDeAsistencia,
					MA.FechaEntrada AS FechaEntrada,
					MA.FechaSalida AS FechaSalida,
					MA.IdJornada AS IdJornada,
					MH.Id AS IdMovimientoHora,
					MH.IdMarcaAsistencia AS IdMarcaAsistencia,
					MH.Horas AS Horas,
					MP.Id AS IdMovimientoPlanilla,
					MP.Monto AS Monto,
					MP.IdTipoMovimientoPlanilla AS IdTipoMovimientoPlanilla

			FROM
				dbo.MovimientoPlanilla AS MP
				INNER JOIN dbo.MovimientoDeHoras AS MH
				ON MP.Id = MH.Id AND MP.IdPlanillaXSemanaXEmpleado = @inIdPlanillaXSemanaXEmpleado
				INNER JOIN dbo.MarcaDeAsistencia AS MA
				ON MH.IdMarcaAsistencia = MA.Id;
			
        

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