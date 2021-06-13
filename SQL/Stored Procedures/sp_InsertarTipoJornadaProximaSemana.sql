USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE sp_InsertarJornadaProximaSemana
		@inIdTipoJornada INT
		, @inValorDocIdentidad INT
		, @inIdSemanaPlanilla INT
		, @OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inIdTipoJornada INT
		--		, @inValorDocIdentidad INT
		--		, @inIdSemanaPlanilla INT
		--		, @OutResultCode INT OUTPUT

		--EXEC sp_CargarTipoJornadaProximaSemana
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Jornada
					VALUES(
						@inIdTipoJornada
						, (SELECT E.Id FROM dbo.Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad)
						, @inIdSemanaPlanilla
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

				SET @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO