USE[SistemaObrero]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_EliminarDeduccion
	@inIdDeduccionXEmpleado INT
	, @inFechaFin DATE
	, @OutResultCode INT OUTPUT

AS

BEGIN
	SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION
				UPDATE dbo.DeduccionXEmpleado
					SET
						FechaFin = @inFechaFin
					WHERE 
						Id = @inIdDeduccionXEmpleado
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