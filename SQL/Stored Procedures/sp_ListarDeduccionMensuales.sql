USE [SistemaObrero]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DeduccionesMensuales]
    -- Parametros de entrada
    @InPlanilla INT,

    -- Parametros de salida
    @OutResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @OutResultCode = 0

        IF NOT EXISTS (SELECT 1 FROM dbo.PlanillaXMesXEmpleado WHERE Id = @InPlanilla)
        BEGIN
            SET @OutResultCode = 5001            -- Error por si no encuentra la planilla
            RETURN
        END

        SELECT DISTINCT
            DEM.Id,
            TP.Nombre,
            TP.EsObligatoria,
            DPO.Porcentage,
            DEM.TotalDeduccion
        FROM dbo.DeduccionXEmpleadoXMes AS DEM
            INNER JOIN dbo.TipoDeduccion AS TP
                ON TP.Id = DEM.IdTipoDeduccion
            LEFT JOIN dbo.DeduccionPorcentualObligatoria AS DPO
                ON DPO.Id = TP.Id
        WHERE DEM.IdPlanillaXMesXEmpleado = @InPlanilla


    END TRY
    BEGIN CATCH
        IF @@Trancount>0 
            ROLLBACK TRANSACTION Modificacion;

        INSERT INTO dbo.Errores VALUES(
			SUSER_SNAME(),
            ERROR_NUMBER(),
            ERROR_STATE(),
            ERROR_SEVERITY(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE(),
            GETDATE()
        )

        SET @OutResultCode = 501;                -- No se inserto en la tabla

    END CATCH

    SET NOCOUNT OFF

END
