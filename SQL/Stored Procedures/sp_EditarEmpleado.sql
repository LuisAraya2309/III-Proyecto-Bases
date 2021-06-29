USE [SistemaObrero]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.sp_EditarEmpleado 
	@inBuscarNombre VARCHAR(40)
	, @inNuevoNombre VARCHAR(40)
	, @inBuscarTipoIdentificacion  VARCHAR(40) 
	, @inNuevoValorIdentidad INT
	, @inBuscarPuesto VARCHAR(40)
	, @inBuscarDepartamento  VARCHAR(40)
	, @OutResultCode INT OUTPUT
--Este procedimiento edita un empleado el cual es buscado por su nombre, y se cambian sus atributos por los parametros
AS

BEGIN
	SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			---Realiza la busqueda del puesto segun su nombre y devuelve el valor de su id
			DECLARE 
				@nuevoPuesto INT  
				= (SELECT 
				P.Id 
			FROM dbo.Puestos AS P
			WHERE 
				P.Nombre = @inBuscarPuesto);

			---Realiza la busqueda del tipo documento de identificacion segun su nombre y devuelve el valor de su id
			DECLARE 
				@nuevoTipoIdentificacion INT  
			= (SELECT 
				T.Id 
			FROM dbo.TipoDocIdentidad AS T
			WHERE 
				T.Nombre = @inBuscarTipoIdentificacion);

			---Realiza la busqueda del puesto segun su nombre y devuelve el valor de su id
			DECLARE 
				@nuevoDepartamento INT 
			= (SELECT 
				D.Id 
			FROM dbo.Departamento AS D
			WHERE 
				D.Nombre = @inBuscarDepartamento);

			BEGIN TRANSACTION 
				UPDATE dbo.Empleados
					SET 
						Nombre = @inNuevoNombre
						, ValorDocumentoIdentidad = @inNuevoValorIdentidad
						, IdDepartamento = @nuevoDepartamento
						, IdPuesto = @nuevoPuesto
						, IdTipoDocumentoIdentidad = @nuevoTipoIdentificacion
					WHERE 
						Nombre = @inBuscarNombre
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
