USE [SistemaObrero]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_EditarMontoDeducciones
	@inIdDeduccionXEmpleado INT
	, @inNuevoValor FLOAT
	, @inTipoMonto BIT
	, @OutResultCode INT OUTPUT
AS

BEGIN
	--DECLARE @inIdDeduccionXEmpleado INT = 388
	-- , @inNuevoValor FLOAT = 20000
	-- , @inTipoMonto BIT = 1
	-- , @OutResultCode INT OUTPUT= 0

	--EXEC sp_EditarMontoDeducciones 
	-- @inIdDeduccionXEmpleado
	-- , @inNuevoValor
	-- , @inTipoMonto
	-- , @OutResultCode

	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0 ;

		BEGIN TRANSACTION

			-- Se edita el monto de la deduccion dependiendo de si son fijas no obligatorias o porcentual no obligatoria

			UPDATE dbo.DeduccionXEmpleadoNoObligatoriaPorcentual
			SET 
				Porcentage = @inNuevoValor
			WHERE 
				Id = @inIdDeduccionXEmpleado AND
				@inTipoMonto = 0

			UPDATE dbo.FijaNoObligatoria
			SET 
				Monto = @inNuevoValor
			WHERE 
				Id = @inIdDeduccionXEmpleado AND
				@inTipoMonto = 1

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
