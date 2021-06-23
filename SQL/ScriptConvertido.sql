USE SistemaObrero;
SET LANGUAGE Spanish;
SET NOCOUNT ON;
--CARGA EL XML

DECLARE @docXML XML = (SELECT dbo.CargarXML())



-- C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\III-Proyecto-Bases\SQL\Datos_Tarea3.xml
	-- C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea3.xml


--CARGA DE CATALOGOS----------------------------------------------------------------

--Puestos
EXEC sp_CargarPuestos @docXML,0;

--Departamentos
EXEC sp_CargarDepartamentos @docXML,0;

--Tipos de Documento de Identificacion
EXEC sp_CargarTipoDocIdentidad @docXML,0;

--Tipos de Jornada
EXEC sp_CargarTipoJornada @docXML,0;

--Tipos de Movimientos
EXEC sp_CargarTipoMovimientoPlanilla @docXML,0;

--Feriados
EXEC sp_CargarFeriados @docXML,0;

--Deducciones
EXEC sp_CargarTipoDeduccion @docXML,0;




--Preparar la simulacion---------------------------------------------------------------
--Se crea una tabla que va a contener una fecha y una operacion, ambos relacionados
CREATE TABLE #Operaciones(Fecha DATE,Operacion XML);

DECLARE @fechaActual DATE;
DECLARE @ultimaFecha DATE;
DECLARE @indiceNodo INT;

SELECT TOP 1 @fechaActual = Item.value('@Fecha','DATE')
FROM @docXML.nodes('Datos/Operacion') AS T(Item)


SELECT @ultimaFecha = Item.value('@Fecha','DATE')
FROM @docXML.nodes('Datos/Operacion') AS T(Item)



SELECT @indiceNodo = 1;
WHILE (@fechaActual<=@ultimaFecha)
	BEGIN
		INSERT INTO #Operaciones
			VALUES(
				@fechaActual,
				@docXML.query('/Datos/Operacion[sql:variable("@indiceNodo")]')
				)
				SET @fechaActual = DATEADD(DAY,1,@fechaActual);
				SELECT @indiceNodo = @indiceNodo + 1; 
	END

--Preparo las variables de mes y semana para empezar a iterar operacion por operacion
SELECT TOP 1 @fechaActual = Item.value('@Fecha','DATE')
FROM @docXML.nodes('Datos/Operacion') AS T(Item)

DECLARE @secInicial INT,@secFinal INT,@secItera INT,@mensajeError VARCHAR(100);

--Variables para insertar empleados

DECLARE @EmpleadosTemp TABLE(
	Nombre VARCHAR(64), 
	ValorDocumentoIdentidad INT,
	FechaNacimiento DATE,
	IdPuesto INT,
	IdDepartamento INT,
	IdTipoDocumentoIdentidad INT, 
	NombreUsuario VARCHAR(64),
	Contraseña VARCHAR(64),
	Tipo INT,
	Secuencia INT,
	ProduceError BIT,
	Activo BIT
	)

DECLARE @Nombre VARCHAR(40), @ValorDocumentoIdentidad INT, @FechaNacimiento DATE, @IdPuesto INT,
	@IdDepartamento INT,@IdTipoDocumentoIdentidad INT,@NombreUsuario VARCHAR(64),@Contraseña VARCHAR(64), 
	@produceError BIT 

--Variables para insertar en Jornada
DECLARE @JornadaTemp TABLE (
	IdJornada INT,
	ValorDocIdentidad INT,
	IdSemanaPlanilla INT,
	Secuencia INT,
	ProduceError BIT
	)

DECLARE @IdJornada INT, @ValorDocIdentidad INT, @IdSemanaPlanilla INT 

--Variables para eliminar Empleado

DECLARE @EliminacionesEmpleados TABLE(
	ValorDocIdentidad INT,
	Secuencia INT,
	ProduceError BIT
	)

DECLARE @ValorDocId  INT

--Asociar deducciones
DECLARE @fechaInicioDedu DATE;
DECLARE @idMaximoSemanaPlanilla INT;
DECLARE @fechaDedu DATE,@IdTipoDeduccion INT,@montoDeduccion VARCHAR(20);



DECLARE @AsociaDeduccionTemp TABLE (
	ValorDocumentoIdentidad INT, 
	IdTipoDeduccion INT,
	Monto VARCHAR(20),
	Secuencia INT,
	ProduceError BIT
	)



--Desasociar deduccion del empleado

DECLARE @fechaDeduFin DATE;
DECLARE @DesasociaEmpleado TABLE(
	ValorDocumentoIdentidad INT,
	IdTipoDeduccion INT,
	Secuencia INT,
	ProduceError BIT
)

--Marcas de Asistencia

DECLARE @MarcasAux TABLE (
	FechaInicio SMALLDATETIME,
	FechaFin SMALLDATETIME,
	IdJornada INT,
	Secuencia INT,
	ProduceError BIT)

DECLARE @fechaInicio SMALLDATETIME , @fechaFin SMALLDATETIME, 
	@idEmpleado INT , @horasTrabajadas INT , @horaFinNormal TIME(0) , 
	@idTipoJornada INT , @horasExtra INT ,  @salarioXHora INT , 
	@horasExtrasDoble INT, @gananciasOrdinarias FLOAT, @ganaciasExtra FLOAT,
	@gananciasExtraDoble FLOAT;



--Para generar los movimientos de las deducciones
DECLARE @empleadosDeducciones TABLE(
	Id INT,
	FechaInicio DATE,
	FechaFin DATE,
	IdEmpleado INT,
	IdTipoDeduccion INT
)

DECLARE @idDE INT,@idEmpleadoDE INT, @fechaInicioDE DATE, @fechaFinDE DATE, @idTipoDeduccionDE INT, @iterarED INT, @montoDeduccionED INT;
--INICIO DE LA ITERACION DE OPERACION POR OPERACION
WHILE @fechaActual<='2020-11-06'
		BEGIN

			--Crea una instancia de Corrida
			INSERT INTO dbo.Corrida
				VALUES
				(
				@fechaActual,
				1,
				GETDATE()
				)

			--Se guarda en una variable de tipo XML el nodo que se va a procesar 
			--para que el acceso sea mas sencillo en las operaciones
			DECLARE @nodoActual XML;
			SELECT @nodoActual = CONVERT(XML,Operacion)
			FROM
			#Operaciones WHERE Fecha = @fechaActual;

		
			--Se verifica si la fecha corresponde a cierre de semana y cambio de mes
			IF DATEPART(WEEKDAY, @fechaActual) = 4
				BEGIN
					IF(DATENAME(MONTH,DATEADD(DAY,1,@fechaActual)) <> DATENAME(MONTH,DATEADD(DAY,-6,@fechaActual)))
					BEGIN
						DECLARE @Semanas INT = 0
						DECLARE @RecorrerSemanas DATE = (SELECT DATEADD(DAY,1,@fechaActual))
						WHILE (DATENAME(MONTH,DATEADD(DAY,1,@fechaActual)) = (DATENAME(MONTH,@RecorrerSemanas)))
							BEGIN
								SET @RecorrerSemanas = (SELECT DATEADD(WEEK,1,@RecorrerSemanas))
								SET @Semanas = @Semanas+1
							END
						INSERT INTO dbo.MesPlanilla
							VALUES((SELECT DATEADD(DAY,1,@fechaActual)), (SELECT DATEADD(DAY,7*@Semanas,@fechaActual)))
						

					END

					INSERT INTO dbo.SemanaPlanilla
						VALUES((SELECT DATEADD(DAY,1,@fechaActual)), (SELECT DATEADD(DAY,7,@fechaActual)), (SELECT MAX(Id) AS Id FROM dbo.MesPlanilla))
							
			
				END

		

			--Se empieza a ejecutar la accion dependiendo del tag


			--Agregar nuevo empleado

			IF ((SELECT Operacion.exist('Operacion/NuevoEmpleado') FROM #Operaciones WHERE Fecha = @fechaActual)=1)
				BEGIN
					
					INSERT INTO @EmpleadosTemp
						SELECT  
								Item.value('@Nombre','VARCHAR(64)') AS Nombre,
								Item.value('@ValorDocumentoIdentidad','INT') AS ValorDocumentoIdentidad,
								Item.value('@FechaNacimiento','DATE') AS FechaNacimiento,
								Item.value('@idPuesto','INT') AS IdPuesto,
								Item.value('@idDepartamento','INT') AS IdDepartamento,
								Item.value('@idTipoDocumentacionIdentidad','INT') AS IdTipoDocumentoIdentidad,
								Item.value('@Username','VARCHAR(64)') AS NombreUsuario,
								Item.value('@Password','VARCHAR(64)') AS Contraseña,
								1,
								Item.value('@Secuencia','INT') AS Secuencia,
								Item.value('@ProduceError','BIT') AS ProduceError,
								1 AS Activo

						FROM @nodoActual.nodes('Operacion/NuevoEmpleado') AS T(Item)

				
					SELECT @secInicial = MIN(Secuencia) , @secFinal = MAX(Secuencia) FROM @EmpleadosTemp;
					SELECT @secItera = @secInicial;
					WHILE @secItera<=@secFinal 
						BEGIN
							SELECT @Nombre  = (SELECT TOP(1) Nombre FROM @EmpleadosTemp);
							SELECT @ValorDocumentoIdentidad  =  (SELECT TOP(1) ValorDocumentoIdentidad FROM @EmpleadosTemp);
							SELECT @FechaNacimiento  = (SELECT TOP(1) FechaNacimiento FROM @EmpleadosTemp);
							SELECT @IdPuesto = (SELECT TOP(1) IdPuesto FROM @EmpleadosTemp);
							SELECT @IdDepartamento =  (SELECT TOP(1) IdDepartamento FROM @EmpleadosTemp);
							SELECT @IdTipoDocumentoIdentidad = (SELECT TOP(1) IdTipoDocumentoIdentidad FROM @EmpleadosTemp);
							SELECT @NombreUsuario  = (SELECT TOP(1) NombreUsuario FROM @EmpleadosTemp);
							SELECT @Contraseña  = (SELECT TOP(1) Contraseña FROM @EmpleadosTemp);
							SELECT @produceError  = (SELECT TOP(1) ProduceError FROM @EmpleadosTemp);
							/*
							IF @produceError = 1
								BEGIN
									PRINT('Entro')
									DELETE TOP (1) FROM @EmpleadosTemp
									SELECT @secItera = @secItera + 1;
									SELECT @mensajeError = 'Hubo un error en la insercion del empleado de identificacion: ' + CONVERT(VARCHAR,@ValorDocumentoIdentidad);
									
									--AGREGAR A LA BITACORA EL ERROR
									INSERT INTO dbo.BitacoraErrores
										VALUES
										(
										@fechaActual,
										@mensajeError
										)
								
									CONTINUE;
								END
							*/
							EXEC sp_InsertarEmpleado
								@Nombre
								, @ValorDocumentoIdentidad
								, @FechaNacimiento
								, @IdPuesto
								, @IdDepartamento
								, @IdTipoDocumentoIdentidad
								, @NombreUsuario
								, @Contraseña
								, 0

							INSERT INTO dbo.DetalleCorrida
								VALUES
								(
								(SELECT MAX(Id) FROM dbo.Corrida),
								1,
								@secItera
								)

							DELETE TOP (1) FROM @EmpleadosTemp
							SELECT @secItera = @secItera + 1;
						END
					DELETE FROM @EmpleadosTemp;
				END
		



			--Insertar Tipo Jornada Proxima Semana
			
			IF ((SELECT Operacion.exist('Operacion/TipoDeJornadaProximaSemana') FROM #Operaciones WHERE Fecha = @fechaActual)=1)
				BEGIN
					INSERT INTO @JornadaTemp
						SELECT 
							tipoJornadaProximaSemana.value('@IdJornada','INT') AS idJornada,
							tipoJornadaProximaSemana.value('@ValorDocumentoIdentidad','INT') AS ValorDocIdentidad ,
							(SELECT IDENT_CURRENT('SemanaPlanilla')),
							tipoJornadaProximaSemana.value('@Secuencia','INT') AS Secuencia,
							tipoJornadaProximaSemana.value('@ProduceError','BIT') AS ProduceError

						FROM @nodoActual.nodes('Operacion/TipoDeJornadaProximaSemana') AS T(tipoJornadaProximaSemana)

					SELECT @secInicial = MIN(Secuencia) , @secFinal = MAX(Secuencia) FROM @JornadaTemp;
					SELECT @secItera = @secInicial;

					WHILE @secItera<=@secFinal 
						BEGIN
							SELECT @IdJornada = (SELECT TOP(1) IdJornada FROM @JornadaTemp)
							SELECT @ValorDocIdentidad =  (SELECT TOP(1) ValorDocIdentidad FROM @JornadaTemp)
							SELECT @IdSemanaPlanilla = (SELECT TOP(1) IdSemanaPlanilla FROM @JornadaTemp)
							SELECT @produceError  = (SELECT TOP(1) ProduceError FROM @JornadaTemp);

							IF @produceError = 1
								BEGIN
									DELETE TOP (1) FROM @JornadaTemp
									SELECT @secItera = @secItera + 1;
									SELECT @mensajeError = 'Hubo un error en la insercion de la jornada proxima semana del empleado con valor de documento de identidad: ' + CONVERT(VARCHAR,@ValorDocIdentidad);
									
									--AGREGAR A LA BITACORA EL ERROR
									INSERT INTO dbo.BitacoraErrores
										VALUES
										(
										@fechaActual,
										@mensajeError
										)
								
									CONTINUE;
								END

							EXEC sp_InsertarJornadaProximaSemana
								@IdJornada
								, @ValorDocIdentidad
								, @IdSemanaPlanilla
								, 0 

							INSERT INTO dbo.DetalleCorrida
								VALUES
								(
								(SELECT MAX(Id) FROM dbo.Corrida),
								5,
								@secItera
								)

							DELETE TOP (1) FROM @JornadaTemp
							SELECT @secItera = @secItera + 1;
						END
					DELETE FROM @JornadaTemp
				END
			
			--Eliminar Empleado
			
			IF ((SELECT Operacion.exist('Operacion/EliminarEmpleado') FROM #Operaciones WHERE Fecha = @fechaActual)=1)

				BEGIN
					INSERT INTO @EliminacionesEmpleados
						SELECT 
							Item.value('@ValorDocumentoIdentidad','INT') as valorDocIdentidad,
							Item.value('@Secuencia','INT') as Secuencia,
							Item.value('@ProduceError','BIT') as ProduceError
						FROM @nodoActual.nodes('Operacion/EliminarEmpleado') AS T(Item)
					
					SELECT @secInicial = MIN(Secuencia) , @secFinal = MAX(Secuencia) FROM @EliminacionesEmpleados;
					SELECT @secItera = @secInicial;
					WHILE @secItera<=@secFinal 
						BEGIN
							SELECT @ValorDocId = (SELECT TOP(1) ValorDocIdentidad FROM @EliminacionesEmpleados)
							SELECT @produceError  = (SELECT TOP(1) ProduceError FROM @EliminacionesEmpleados);

							IF @produceError = 1
								BEGIN
									DELETE TOP (1) FROM @EliminacionesEmpleados
									SELECT @secItera = @secItera + 1;
									SELECT @mensajeError = 'Hubo un error eliminando al empleado con valor de documento de identidad: ' + CONVERT(VARCHAR,@ValorDocId);
									
									--AGREGAR A LA BITACORA EL ERROR
									INSERT INTO dbo.BitacoraErrores
										VALUES
										(
										@fechaActual,
										@mensajeError
										)
								
									CONTINUE;
								END

							EXEC sp_EliminarEmpleados
								@ValorDocId
								, 0

							INSERT INTO dbo.DetalleCorrida
								VALUES
								(
								(SELECT MAX(Id) FROM dbo.Corrida),
								2,
								@secItera
								)

							DELETE TOP (1) FROM @EliminacionesEmpleados
							SELECT @secItera = @secItera + 1;
						END
				
					DELETE FROM @EliminacionesEmpleados;

				END
			
			
			--Asociar Empleado con Deduccion
			
			IF ((SELECT Operacion.exist('Operacion/AsociaEmpleadoConDeduccion') FROM #Operaciones WHERE Fecha = @fechaActual)=1)
				BEGIN
					INSERT INTO @AsociaDeduccionTemp
						SELECT 
							AsociaDeduccion.value('@ValorDocumentoIdentidad','INT'),
							AsociaDeduccion.value('@IdDeduccion','INT'),
							AsociaDeduccion.value('@Monto','VARCHAR(20)'),
							AsociaDeduccion.value('@Secuencia','INT'),
							AsociaDeduccion.value('@ProduceError','BIT')
	
							
					FROM @nodoActual.nodes('Operacion/AsociaEmpleadoConDeduccion') AS T(AsociaDeduccion)
				
					SELECT @secInicial = MIN(Secuencia) , @secFinal = MAX(Secuencia) FROM @AsociaDeduccionTemp;
					SELECT @secItera = @secInicial;
					WHILE @secItera<=@secFinal 
						BEGIN
							SELECT @fechaInicioDedu  = (SELECT FechaInicio FROM SemanaPlanilla WHERE Id = (SELECT MAX(Id) FROM SemanaPlanilla) );
							SELECT @idEmpleado  = (SELECT Id FROM Empleados WHERE ValorDocumentoIdentidad = (SELECT TOP (1) ValorDocumentoIdentidad FROM @AsociaDeduccionTemp));
							SELECT @idTipoDeduccion  = (SELECT TOP(1) IdTipoDeduccion FROM @AsociaDeduccionTemp);
							SELECT @montoDeduccion = (SELECT TOP(1) Monto FROM @AsociaDeduccionTemp);
							SELECT @produceError  = (SELECT TOP(1) ProduceError FROM @AsociaDeduccionTemp);

							IF (@produceError = 1)
								BEGIN
									DELETE TOP (1) FROM @AsociaDeduccionTemp
									SELECT @secItera = @secItera + 1;
									SELECT @mensajeError = 'Hubo un error asociando al empleado con valor de documento de identidad ' + CONVERT(VARCHAR,@ValorDocId) + ' con la deduccion de tipo '+ CONVERT(VARCHAR, @idTipoDeduccion);
									
									--AGREGAR A LA BITACORA EL ERROR
									INSERT INTO dbo.BitacoraErrores
										VALUES
										(
										@fechaActual,
										@mensajeError
										)
								
									CONTINUE;
								END


							SELECT @idEmpleado = (SELECT Id FROM dbo.Empleados WHERE ValorDocumentoIdentidad = @ValorDocumentoIdentidad)
							SELECT @idMaximoSemanaPlanilla =  MAX(Id) FROM dbo.SemanaPlanilla

							IF DATEPART(WEEKDAY, @fechaActual) = 4
								BEGIN
									SELECT @fechaInicioDedu = (SELECT FechaInicio FROM dbo.SemanaPlanilla WHERE Id = @idMaximoSemanaPlanilla)
								END
							ELSE
								BEGIN 
									SELECT @fechaInicioDedu = (SELECT DATEADD(DAY, 1 , (SELECT FechaFinal FROM dbo.SemanaPlanilla WHERE Id = @idMaximoSemanaPlanilla)))
								END

							INSERT INTO DeduccionXEmpleado 
								VALUES(@fechaInicioDedu,NULL,@idEmpleado,@IdTipoDeduccion)
							
							IF CHARINDEX('.',@montoDeduccion) = 0
								INSERT INTO dbo.FijaNoObligatoria
									VALUES
									(
									(SELECT MAX(Id) FROM dbo.DeduccionXEmpleado),
									(CONVERT(FLOAT,@montoDeduccion))
									)
							ELSE
								INSERT INTO dbo.DeduccionXEmpleadoNoObligatoriaPorcentual
									VALUES
									(
									(SELECT MAX(Id) FROM dbo.DeduccionXEmpleado),
									(CONVERT(FLOAT,@montoDeduccion))
									)

							
							INSERT INTO dbo.DetalleCorrida
								VALUES
								(
								(SELECT MAX(Id) FROM dbo.Corrida),
								3,
								@secItera
								)

							DELETE TOP (1) FROM @AsociaDeduccionTemp
							SELECT @secItera = @secItera + 1;
						END
					DELETE FROM @AsociaDeduccionTemp;	
				END
		
		--Desasociar Empleado con Deduccion
		
		IF ((SELECT Operacion.exist('Operacion/DesasociaEmpleadoConDeduccion') FROM #Operaciones WHERE Fecha = @fechaActual)=1)	
				BEGIN
					INSERT INTO @DesasociaEmpleado
						SELECT
							DesasociaEmpleado.value('@ValorDocumentoIdentidad','INT'),
							DesasociaEmpleado.value('@IdDeduccion','INT'),
							DesasociaEmpleado.value('@Secuencia','INT'),
							DesasociaEmpleado.value('@ProduceError','BIT')

					FROM @nodoActual.nodes('Operacion/DesasociaEmpleadoConDeduccion') AS T(DesasociaEmpleado)
					SELECT @secInicial = MIN(Secuencia) , @secFinal = MAX(Secuencia) FROM @DesasociaEmpleado;
					SELECT @secItera = @secInicial;
					WHILE @secItera<=@secFinal
						BEGIN
							SELECT @ValorDocumentoIdentidad = (SELECT TOP(1) ValorDocumentoIdentidad FROM @DesasociaEmpleado);
							SELECT @IdTipoDeduccion = (SELECT TOP(1) IdTipoDeduccion FROM @DesasociaEmpleado);
							SELECT @produceError = (SELECT TOP(1) ProduceError FROM @DesasociaEmpleado);
							SELECT @idEmpleado = (SELECT Id FROM dbo.Empleados WHERE ValorDocumentoIdentidad = @ValorDocumentoIdentidad)
							SELECT @idMaximoSemanaPlanilla =  MAX(Id) FROM dbo.SemanaPlanilla

							IF @produceError = 1
								BEGIN
									DELETE TOP (1) FROM @DesasociaEmpleado
									SELECT @secItera = @secItera + 1;
									SELECT @mensajeError = 'Hubo un error desasociando al empleado con valor de documento de identidad ' + CONVERT(VARCHAR,@ValorDocId) + ' con la deduccion de tipo '+ CONVERT(VARCHAR, @idTipoDeduccion);
									
									--AGREGAR A LA BITACORA EL ERROR
									INSERT INTO dbo.BitacoraErrores
										VALUES
										(
										@fechaActual,
										@mensajeError
										)
								
									CONTINUE;
								END

							IF DATEPART(WEEKDAY, @fechaActual) = 4
								BEGIN
									SELECT @fechaDeduFin = (SELECT DATEADD(DAY, -1 , (SELECT FechaFinal FROM dbo.SemanaPlanilla WHERE Id = @idMaximoSemanaPlanilla)))
								END
							ELSE
								BEGIN 
									SELECT @fechaDeduFin = (SELECT FechaFinal FROM dbo.SemanaPlanilla WHERE Id = @idMaximoSemanaPlanilla)
								END

							UPDATE DeduccionXEmpleado 
								SET FechaFin = @fechaDeduFin
								WHERE IdEmpleado = @idEmpleado AND IdTipoDeduccion = @IdTipoDeduccion

							
							DELETE TOP (1) FROM @DesasociaEmpleado;
							SELECT @secItera = @secItera + 1;
						END
						
				END
				DELETE FROM @DesasociaEmpleado;
				
			--Marcas de Asistencias
			
			IF ((SELECT Operacion.exist('Operacion/MarcaDeAsistencia') FROM #Operaciones WHERE Fecha = @fechaActual)=1)
				BEGIN
					
					INSERT INTO @MarcasAux
						SELECT
							marcaAsistencia.value('@FechaEntrada','SMALLDATETIME') AS fechaEntrada,
							marcaAsistencia.value('@FechaSalida','SMALLDATETIME') AS fechaSalida,
							(SELECT TOP 1 
								J.id 
							FROM dbo.Jornada AS J 
							WHERE 
								J.IdEmpleado IN (SELECT TOP 1 
													E.Id 
												FROM dbo.Empleados AS E 
												WHERE 
													E.ValorDocumentoIdentidad = marcaAsistencia.value('@ValorDocumentoIdentidad','INT'))),
							marcaAsistencia.value('@Secuencia','INT') AS Secuencia,
							marcaAsistencia.value('@ProduceError','BIT') AS ProduceError


						FROM @nodoActual.nodes('Operacion/MarcaDeAsistencia') AS T(marcaAsistencia)

					
					SELECT @secInicial = MIN(Secuencia) , @secFinal = MAX(Secuencia) FROM @MarcasAux;
					SELECT @secItera = @secInicial;

					WHILE @secItera<=@secFinal 
						BEGIN
							SELECT @fechaInicio  =  CONVERT(SMALLDATETIME,(SELECT TOP(1) FechaInicio FROM @MarcasAux));
							SELECT @fechaFin  =  CONVERT(SMALLDATETIME,(SELECT TOP(1) FechaFin FROM @MarcasAux));
							SELECT @idJornada  = (SELECT TOP(1) IdJornada FROM @MarcasAux);
							SELECT @idEmpleado  = (SELECT IdEmpleado FROM Jornada WHERE Jornada.Id = @idJornada);
							SELECT @horasTrabajadas  = DATEDIFF(HOUR,@fechaInicio,@fechaFin); --Calcula las horas trabajadas en la sesion
							SELECT @idTipoJornada  = (SELECT Jornada.IdTipoJornada FROM Jornada WHERE  Id =  @idJornada );
							SELECT @horasExtra  = 0, @horasExtrasDoble = 0; 
							SELECT @salarioXHora  = (SELECT 
														SalarioXHora 
													FROM Puestos 
													WHERE 
														Puestos.Id = (SELECT IdPuesto FROM Empleados WHERE Empleados.Id = @idEmpleado));
							SELECT @horaFinNormal = (
								CONVERT(
									TIME(0),
									(SELECT HoraFin FROM TipoJornada WHERE Id = @idTipoJornada)  
									)
							);
							SELECT @produceError  = (SELECT TOP(1) ProduceError FROM @MarcasAux);

							
							IF (DATEPART(WEEKDAY,@fechaActual) = 7) OR (@fechaActual IN (SELECT Fecha FROM Feriados)) --Si es domingo o la fecha es un feriado son horas extra dobles
								BEGIN
									SELECT @horasExtrasDoble = DATEDIFF(HOUR,@horaFinNormal,CONVERT(TIME(0),@fechaFin));
									SELECT @horasExtra = 0;
									SELECT @horasTrabajadas = @horasTrabajadas - @horasExtrasDoble;
								END
							ELSE
								BEGIN
									SELECT @horasExtra = DATEDIFF(HOUR,@horaFinNormal,CONVERT(TIME(0),@fechaFin));
									SELECT @horasExtrasDoble = 0;
									SELECT @horasTrabajadas = @horasTrabajadas - @horasExtra;
								END
							
							--CALCULAR LAS GANANCIAS POR HORA
							
							--Ordinaria
							SELECT @gananciasOrdinarias = (@salarioXHora*@horasTrabajadas);
							
							--Extras
							SELECT @ganaciasExtra = (@salarioXHora*1.5*@horasExtra);

							--Extra Doble
							SELECT @gananciasExtraDoble = (@salarioXHora*2*@horasExtrasDoble);

							SELECT @gananciasOrdinarias,@ganaciasExtra,@gananciasExtraDoble;
							--Inserta la marca de asistencia
							INSERT INTO dbo.MarcaDeAsistencia
								VALUES
								(
								@fechaInicio,
								@fechaFin,                             
								@idJornada
								)
							
							
							--MOVIMIENTO DE HORAS ORDINARIAS
							INSERT INTO dbo.MovimientoPlanilla
								VALUES
								(
								@fechaActual,
								@gananciasOrdinarias,
								1,
								(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado AS PS WHERE PS.IdEmpleado = @idEmpleado)
								)

							UPDATE dbo.PlanillaXSemanaxEmpleado
								SET SalarioBruto = SalarioBruto + @gananciasOrdinarias
								WHERE PlanillaXSemanaxEmpleado.IdEmpleado = @idEmpleado;

							INSERT INTO dbo.MovimientoDeHoras
								VALUES
								(
								(SELECT MAX(Id) FROM dbo.MovimientoPlanilla),
								(SELECT MAX(Id) FROM dbo.MarcaDeAsistencia),
								@horasTrabajadas
								)

								

							IF @horasExtra>0 AND @horasExtrasDoble = 0
								BEGIN
									--MOVIMIENTO DE HORAS EXTRA NORMALES
									INSERT INTO dbo.MovimientoPlanilla
										VALUES
										(
										@fechaActual,
										@ganaciasExtra,
										2,
										(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado AS PS WHERE PS.IdEmpleado = @idEmpleado )
										)

									UPDATE dbo.PlanillaXSemanaxEmpleado
										SET SalarioBruto = SalarioBruto + @ganaciasExtra
										WHERE PlanillaXSemanaxEmpleado.IdEmpleado = @idEmpleado;

									INSERT INTO dbo.MovimientoDeHoras
										VALUES
										(
										(SELECT MAX(Id) FROM dbo.MovimientoPlanilla),
										(SELECT MAX(Id) FROM dbo.MarcaDeAsistencia),
										@horasExtra
										)
								END

							IF @horasExtrasDoble>0 AND @horasExtra = 0
								BEGIN
									--MOVIMIENTO DE HORAS EXTRAS DOBLES
									INSERT INTO dbo.MovimientoPlanilla
									VALUES
									(
									@fechaActual,
									@gananciasExtraDoble,
									3,
									(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado  AS PS WHERE PS.IdEmpleado = @idEmpleado)
									)

									UPDATE dbo.PlanillaXSemanaxEmpleado
										SET SalarioBruto = SalarioBruto + @gananciasExtraDoble
										WHERE PlanillaXSemanaxEmpleado.IdEmpleado = @idEmpleado;

									INSERT INTO dbo.MovimientoDeHoras
										VALUES
										(
										(SELECT MAX(Id) FROM dbo.MovimientoPlanilla),
										(SELECT MAX(Id) FROM dbo.MarcaDeAsistencia),
										@horasExtrasDoble
										)

								END
							


							DELETE TOP (1) FROM @MarcasAux
							SELECT @secItera = @secItera + 1;

						END -- end del while
					
						
					
							
					DELETE FROM @MarcasAux;
				END --end del if
				

			 
			--Iterador 
			SET @fechaActual =  DATEADD(DAY,1,@fechaActual);
		
		END
SET NOCOUNT OFF;
DROP TABLE #Operaciones




