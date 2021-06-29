USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE sp_CargarUsuarios
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--      @inDocXML XML
		--		@OutResultCode INT
		
		--EXEC sp_CargarUsuarios
		--		@inDocXML XML
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Usuarios
					SELECT
						usuario.value('@username','VARCHAR(40)') AS username,
						usuario.value('@pwd','VARCHAR(40)') AS pwd,
						usuario.value('@tipo','INT') AS tipo,
						1 AS activo  
                
					FROM @inDocXML.nodes('Datos/Catalogos/Usuarios/Usuario') AS T(usuario)
					

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

