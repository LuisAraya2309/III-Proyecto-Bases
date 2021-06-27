USE [SistemaObrero]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_EditarMontoDeducciones
	@inNombreTipoDedu VARCHAR(64)
	, @inValorDocIdentidad INT
	, @inNuevoValor FLOAT
	, @inTipoMonto BIT
	, @OutResultCode INT OUTPUT
AS

BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0 ;

		DECLARE @idDeduccionXEmpleado INT, @idEmpleado INT, @idTipoDeduccion INT;
		SET @idEmpleado = (SELECT E.Id FROM Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad);
		SET @idTipoDeduccion = (SELECT TD.id FROM TipoDeduccion AS TD WHERE TD.Nombre = @inNombreTipoDedu);
		SET @idDeduccionXEmpleado = (SELECT DE.id FROM DeduccionXEmpleado AS DE WHERE DE.IdEmpleado = @idEmpleado AND DE.IdTipoDeduccion = @idTipoDeduccion);
		
		IF @inTipoMonto = 0
			BEGIN
				BEGIN TRANSACTION
					UPDATE dbo.DeduccionXEmpleadoNoObligatoriaPorcentual
					SET 
						Porcentage = @inNuevoValor
					WHERE 
						Id = @idDeduccionXEmpleado
				COMMIT TRANSACTION TSaveMov;
			END
		ELSE
			BEGIN
				BEGIN TRANSACTION
					UPDATE dbo.FijaNoObligatoria
					SET 
						Monto = @inNuevoValor
					WHERE 
						Id = @idDeduccionXEmpleado
				COMMIT TRANSACTION TSaveMov;
			END

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
