USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_CargarEmpleados
	@inNombre VARCHAR(40)
	, @inValorDocumentoIdentidad INT
	, @inFechaNacimiento DATE
	, @inIdPuesto INT
	, @inIdDepartamento INT
	, @inIdTipoDocumentacionIdentidad INT
	, @inIdUsuario INT
	, @OutResultCode INT OUTPUT

AS
BEGIN
		--DECLARE
		--	@inNombre VARCHAR(40)
		--	, @inValorDocumentoIdentidad INT
		--	, @FechaNacimiento DATE
		--	, @inIdPuesto INT
		--	, @inIdDepartamento INT
		--	, @inIdTipoDocumentacionIdentidad INT
		--	, @inIdUsuario
		--	, @OutResultCode INT OUTPUT

		--EXEC sp_CargarEmpleados
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Empleado
					VALUES(
						@inNombre
						, @inValorDocumentoIdentidad
						, @inFechaNacimiento
						, @inIdPuesto
						, @inIdDepartamento
						, @inIdTipoDocumentacionIdentidad
						, @inIdUsuario
						, 1
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
