USE[SistemaObrero]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_EliminarDeduccion
	@inIdDeduccionXEmpleado INT
	, @inFechaFin DATE
	, @OutResultCode INT OUTPUT

AS

BEGIN

--DECLARE @inIdDeduccionXEmpleado INT = 388
	-- , @inFechaFin DATE = '2021-06-01'
	-- , @OutResultCode INT OUTPUT= 0

	--EXEC sp_EliminarDeduccion 
	-- @inIdDeduccionXEmpleado
	-- , @inFechaFin
	-- , @OutResultCode

	SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			--Descripcion del cambio para insertarlo en el historial
			DECLARE @descripcion VARCHAR(400),@actualizacion VARCHAR(400),@fechaInicio VARCHAR = CONVERT(VARCHAR,(SELECT DE.FechaInicio FROM DeduccionXEmpleado AS DE WHERE DE.Id = @inIdDeduccionXEmpleado)), 
			@nombreEmpleado VARCHAR(40) = (SELECT E.Nombre FROM Empleados AS E WHERE E.Id = (SELECT DE.IdEmpleado FROM DeduccionXEmpleado AS DE WHERE DE.Id = @inIdDeduccionXEmpleado)),
			@tipoDeduccion VARCHAR = CONVERT(VARCHAR,(SELECT DE.IdTipoDeduccion FROM DeduccionXEmpleado AS DE WHERE DE.Id = @inIdDeduccionXEmpleado));

			SET @descripcion = 'Se elimino la deduccion de id: '+CONVERT(VARCHAR,@inIdDeduccionXEmpleado)+' al empleado: '+@nombreEmpleado +' ,sus valores eran: ' +
				' ,fecha de inicio: ' + @fechaInicio  + ' ,tipo de deduccion:'+ @tipoDeduccion;

			SET @actualizacion = 'Deduccion eliminada con exito su fecha de fin se actualizo a: '+ CONVERT(VARCHAR,@inFechaFin);

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
			
				--Se cambia el atributo de la fecha fin de la deduccion con esto se finaliza su periodo de uso 
				UPDATE dbo.DeduccionXEmpleado
					SET
						FechaFin = @inFechaFin
					WHERE 
						Id = @inIdDeduccionXEmpleado
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