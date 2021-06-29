USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_InsertarEmpleado
	@inNombre VARCHAR(40)
	, @inValorDocumentoIdentidad INT
	, @inFechaNacimiento DATE
	, @inIdPuesto INT
	, @inIdDepartamento INT
	, @inIdTipoDocumentacionIdentidad INT
	, @inUsuario VARCHAR(64)
	, @inContraseña VARCHAR(64)
	, @OutResultCode INT OUTPUT

AS
BEGIN
		

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO dbo.Empleados
					VALUES(
						@inNombre
						, @inValorDocumentoIdentidad
						, @inFechaNacimiento
						, @inIdPuesto
						, @inIdDepartamento
						, @inIdTipoDocumentacionIdentidad
						, 1
					)
				INSERT INTO dbo.Usuarios
					VALUES
						(
						@inUsuario,
						@inContraseña,
						2,
						1
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
