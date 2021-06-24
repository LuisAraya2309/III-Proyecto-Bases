USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_insertarFijaNoObligatoria
	@inIdDeduccionXEmpleado INT
    , @inMontoDeduccion FLOAT
	, @OutResultCode INT OUTPUT

AS
BEGIN
		--DECLARE
	   -- @inIdDeduccionXEmpleado INT
		--, @inMontoDeduccion FLOAT
		--, @OutResultCode INT OUTPUT


		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov

				INSERT INTO dbo.FijaNoObligatoria
					VALUES
					(
					@inIdDeduccionXEmpleado,
					@inMontoDeduccion
					)

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
