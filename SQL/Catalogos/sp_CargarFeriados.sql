
USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE sp_CargarFeriados
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inDocXML
		--		@OutResultCode INT

		--EXEC sp_CargarFeriados
		--		@inDocXMLM,
		--		@OutResultCode

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Feriados
					SELECT
						feriado.value('@Nombre','VARCHAR(64)') AS nombre,
						feriado.value('@Fecha','DATE') AS fecha
					FROM @inDocXML.nodes('Datos/Catalogos/Feriados/Feriado') AS A(feriado)
					
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