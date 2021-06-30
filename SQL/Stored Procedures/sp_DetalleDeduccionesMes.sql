
USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_DetalleDeduccionesMes
    @inIdPlanillaXMesXEmpleado INT,
    @OutResultCode INT OUTPUT

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
			SET @OutResultCode = 0

			--Retorna el detalle de las deducciones x mes la planilla de mes del empleado indicada
			SELECT 
				DM.Id AS Id,
				DM.TotalDeduccion AS TotalDeduccion,
				DM.IdPlanillaXMesXEmpleado AS IdPlanillaXMesXEmpleado,
				DM.IdTipoDeduccion AS IdTipoDeduccion

			FROM dbo.DeduccionXEmpleadoXMes AS DM
			WHERE DM.IdPlanillaXMesXEmpleado  = @inIdPlanillaXMesXEmpleado;

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











