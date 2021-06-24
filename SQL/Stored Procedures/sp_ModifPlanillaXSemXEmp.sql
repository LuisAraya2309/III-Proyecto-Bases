USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_ModifPlanillaXSemXEmp
	@inGanancias FLOAT
    , @inIdEmpleado INT
	, @OutResultCode INT OUTPUT

AS
BEGIN
		--DECLARE
	    -- @gananciasExtraDoble FLOAT
        --, @idEmpleado INT
	    --, @OutResultCode INT OUTPUT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov

				UPDATE dbo.PlanillaXSemanaxEmpleado
					SET SalarioBruto = SalarioBruto + @inGanancias
					WHERE PlanillaXSemanaxEmpleado.IdEmpleado = @inIdEmpleado;

			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;

				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;

END
GO
