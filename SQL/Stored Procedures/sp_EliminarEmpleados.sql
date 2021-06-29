USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_EliminarEmpleados
 	@inValorDocIdentidad INT
	, @OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inValorDocIdentidad
		--		, @OutResultCode INT

		--EXEC sp_CargarEliminarEmpleados
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov

				UPDATE dbo.Empleados
					SET 
						Empleados.Activo = 0
					WHERE 
						Empleados.ValorDocumentoIdentidad = @inValorDocIdentidad;

				UPDATE dbo.Usuarios
					SET 
						Usuarios.Activo = 0
					WHERE 
						Usuarios.Id = (SELECT E.Id FROM Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad)+2;
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