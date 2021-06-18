USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE sp_CargarPuestos
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--      @inDocXML XML
		--		@OutResultCode INT
		
		--EXEC sp_CargarPuestos
		--		@inDocXML XML
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Puestos
					SELECT
						puesto.value('@Id','INT') AS id,
						puesto.value('@Nombre','VARCHAR(40)') AS Nombre,
						puesto.value('@SalarioXHora','FLOAT') AS salarioxHora,
						1 AS activo  
                
					FROM @inDocXML.nodes('Datos/Catalogos/Puestos/Puesto') AS T(puesto)
					

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

