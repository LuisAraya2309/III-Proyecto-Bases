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

		--Descripcion del cambio para insertarlo en el historial
			DECLARE @descripcion VARCHAR(400),@actualizacion VARCHAR(400), @montoAntiguo VARCHAR = CONVERT(VARCHAR,(SELECT FNO.Monto FROM FijaNoObligatoria AS FNO WHERE FNO.Id = @inIdDeduccionXEmpleado)),
			@nombreEmpleado VARCHAR(40) = (SELECT E.Nombre FROM Empleados AS E WHERE E.Id = (SELECT DE.IdEmpleado FROM DeduccionXEmpleado AS DE WHERE DE.Id = @inIdDeduccionXEmpleado)),
			@porcentajeAntiguo VARCHAR = CONVERT(VARCHAR,(SELECT DEO.Porcentage FROM DeduccionXEmpleadoNoObligatoriaPorcentual AS DEO WHERE DEO.Id = @inIdDeduccionXEmpleado));

			SELECT 
				@descripcion = 'Edicion de la deduccion por empleado de id: '+ CONVERT(VARCHAR,@inIdDeduccionXEmpleado) +' del empleado: '+@nombreEmpleado +' ,Valores Antiguos: ' +
				' ,monto: ' + @montoAntiguo
			WHERE @inTipoMonto = 1;

			SELECT 
				@descripcion = 'Edicion de la deduccion por empleado de id: '+ CONVERT(VARCHAR,@inIdDeduccionXEmpleado) +' del empleado: '+@nombreEmpleado +' ,Valores Antiguos: ' +
				' ,monto: ' + @porcentajeAntiguo
			WHERE @inTipoMonto = 0;
			
			SET @actualizacion = 'Edicion de la deduccion por empleado de id: '+ CONVERT(VARCHAR,@inIdDeduccionXEmpleado) + ' del empleado: '+@nombreEmpleado + ',Valores Actualizados: ' +
								' ,monto: ' + CONVERT(VARCHAR,@inNuevoValor);

		BEGIN TRANSACTION TSaveMov
			
			INSERT INTO dbo.Historial
					(
					Fecha,
					Descripcion,
					Actualizacion
					)
					VALUES
					(
					GETDATE(),
					@descripcion,
					@actualizacion
					)

			-- Se edita el monto de la deduccion dependiendo de si son fijas no obligatorias o porcentual no obligatoria

			UPDATE dbo.DeduccionXEmpleadoNoObligatoriaPorcentual
			SET 
				Porcentage = @inNuevoValor
			WHERE 
				Id = @inIdDeduccionXEmpleado AND
				@inTipoMonto = 1

			UPDATE dbo.FijaNoObligatoria
			SET 
				Monto = @inNuevoValor
			WHERE 
				Id = @inIdDeduccionXEmpleado AND
				@inTipoMonto = 0

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