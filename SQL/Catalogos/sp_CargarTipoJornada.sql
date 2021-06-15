
USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE sp_CargarTipoJornada
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inDocXML XML
		--		@OutResultCode INT

		--EXEC sp_CargarTipoJornada
		--		@inDocXML,
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO TipoJornada

					SELECT
						tipoJornada.value('@Id','INT') AS id,
						tipoJornada.value('@Nombre','VARCHAR(40)') AS nombre,
						tipoJornada.value('@HoraEntrada','VARCHAR(40)') AS horaEntrada,
						tipoJornada.value('@HoraSalida','VARCHAR(40)') AS horaSalida
            
					FROM @inDocXML.nodes('Datos/Catalogos/TiposDeJornada/TipoDeJornada') AS A(tipoJornada)
					
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