USE[SistemaObrero]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_AgregarDeduccion
	@inNombreEmpleado VARCHAR(40)
	, @inFechaInicio DATE
	, @inBuscarNombreTipoDedu  VARCHAR(40) 
	, @inNuevoMonto FLOAT
	, @inTipoMonto BIT 
	, @OutResultCode INT OUTPUT


AS

BEGIN
	SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION
				INSERT INTO DeduccionXEmpleado (FechaInicio, IdEmpleado, IdTipoDeduccion)
					VALUES(
						@inFechaInicio,
						(SELECT E.ID FROM Empleados AS E WHERE E.Nombre = @inNombreEmpleado),
						(SELECT TD.id FROM TipoDeduccion AS TD WHERE TD.Nombre = @inBuscarNombreTipoDedu)
					)
			
				INSERT INTO dbo.DeduccionXEmpleadoNoObligatoriaPorcentual (
					Id,
					Porcentage
				)
				SELECT
					(SELECT MAX(DE.id)FROM DeduccionXEmpleado AS DE),
					@inTipoMonto
				WHERE @inTipoMonto = 0
		
				INSERT INTO dbo.FijaNoObligatoria(
					Id,
					Monto
				)
				SELECT
					(SELECT MAX(DE.id)FROM DeduccionXEmpleado AS DE),
					@inTipoMonto
				WHERE @inTipoMonto = 0

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