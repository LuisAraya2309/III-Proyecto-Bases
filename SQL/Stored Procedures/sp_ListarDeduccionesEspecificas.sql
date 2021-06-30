USE [SistemaObrero]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DeduccionesSemanales]
    -- Parametros de entrada
    @InPlanilla INT,

    -- Parametros de salida
    @OutResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @OutResultCode = 0

        IF NOT EXISTS (SELECT 1 FROM dbo.PlanillaXSemanaXEmpleado WHERE Id = @InPlanilla)
        BEGIN
            SET @OutResultCode = 5001    
            RETURN
        END

        SELECT DISTINCT
            DE.Id,
            TP.Nombre,
            TP.EsObligatoria,
            DPO.Porcentage,
            MP.Monto * -1 AS Monto
        FROM dbo.DeduccionXEmpleado AS DE 
            INNER JOIN dbo.MovimientoDeduccion AS MD
                ON De.Id = MD.IdDeduccionXEmpleado
            INNER JOIN dbo.MovimientoPlanilla AS MP
                ON MP.Id = MD.Id
            INNER JOIN dbo.TipoDeduccion AS TP
                ON TP.Id = DE.IdTipoDeduccion
            LEFT JOIN dbo.DeduccionPorcentualObligatoria AS DPO
                ON DPO.Id = TP.Id
        WHERE MP.IdPlanillaXSemanaXEmpleado = @InPlanilla


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

        SET @OutResultCode = 501;  

    END CATCH

    SET NOCOUNT OFF

END
