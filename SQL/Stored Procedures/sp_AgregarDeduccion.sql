USE[SistemaObrero]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_AgregarDeduccion
	@inValorDocIdentidad VARCHAR(40)
	, @inFechaInicio DATE
	, @inBuscarNombreTipoDedu VARCHAR(40) 
	, @inNuevoMonto FLOAT
	, @inTipoMonto BIT 
	, @OutResultCode INT OUTPUT

AS

BEGIN

	--DECLARE @inValorDocIdentidad VARCHAR(40) = 55186659
	-- , @inFechaInicio DATE = '2021-03-12'
	-- , @inBuscarNombreTipoDedu VARCHAR(40) = "Ahorro de Vivienda"
	-- , @inNuevoMonto FLOAT = 15000
	-- , @inTipoMonto BIT = 1
	-- , @OutResultCode INT OUTPUT = 0

	--EXEC sp_AgregarDeduccion 
	-- @inValorDocIdentidad 
	-- , @inFechaInicio 
	-- , @inBuscarNombreTipoDedu 
	-- , @inNuevoMonto 
	-- , @inTipoMonto 
	-- , @OutResultCode

	SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION
				INSERT INTO DeduccionXEmpleado (FechaInicio, IdEmpleado, IdTipoDeduccion)
					VALUES(
						@inFechaInicio,
						(SELECT E.ID FROM Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad),
						(SELECT TD.id FROM TipoDeduccion AS TD WHERE TD.Nombre = @inBuscarNombreTipoDedu)
					)
			
				INSERT INTO dbo.DeduccionXEmpleadoNoObligatoriaPorcentual (
					Id,
					Porcentage
				)
				SELECT
					(SELECT MAX(DE.id)FROM DeduccionXEmpleado AS DE),
					@inNuevoMonto
				WHERE @inTipoMonto = 0
		
				INSERT INTO dbo.FijaNoObligatoria(
					Id,
					Monto
				)
				SELECT
					(SELECT MAX(DE.id)FROM DeduccionXEmpleado AS DE),
					@inNuevoMonto
				WHERE @inTipoMonto = 1

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
