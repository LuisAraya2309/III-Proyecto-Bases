USE [SistemaObrero]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.sp_ListarPlanillaMensual
    @inValorDocIdentidad INT,
    @OutResultCode INT OUTPUT

	--Codigo Ejemplo para probar este SP
	/*
	  EXEC sp_ListarPlanillaMensual 39936325,0
	*/

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SET @OutResultCode = 0

        IF NOT EXISTS (SELECT 1 FROM dbo.Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad)
        BEGIN
            SET @OutResultCode = 5001            -- Error por si no encuentra el empleado
            RETURN
        END

		--Retorna la seleccion de todas las planillas mensuales
        SELECT 
            PMes.Id,
            PMes.SalarioBruto,
            PMes.SalarioNeto,
            PMes.SalarioBruto - PMes.SalarioNeto AS TotalDeducciones,
            PMes.IdMesPlanilla
        FROM dbo.PlanillaXMesXEmpleado AS PMes
        WHERE PMes.IdEmpleado = (SELECT E.Id FROM dbo.Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad)
        ORDER BY (PMes.Id)DESC

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
