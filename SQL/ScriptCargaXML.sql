USE SistemaObrero;
SET LANGUAGE Spanish;

DECLARE @docXML XML = (
SELECT * FROM(
	SELECT CAST(c AS XML) FROM
	OPENROWSET(
		BULK 'C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea3.xml',SINGLE_BLOB) AS T(c)
	) AS S(C)
)

-- C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\III-Proyecto-Bases\SQL\Datos_Tarea3.xml
	-- C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea3.xml


--CATALOGOS----------------------------------------------------------------
--Puestos
INSERT INTO Puestos

	SELECT
		puesto.value('@Id','INT') AS id,
		puesto.value('@Nombre','VARCHAR(40)') AS Nombre,
		puesto.value('@SalarioXHora','INT') AS salarioxHora,
		1 AS activo
	
	FROM @docXML.nodes('Datos/Catalogos/Puestos/Puesto') AS T(puesto)

--Departamento
INSERT INTO Departamento

	SELECT
		departamento.value('@Id','INT') AS id,
		departamento.value('@Nombre','VARCHAR(40)') AS nombre, 
		1 AS activo
			
	FROM @docXML.nodes('Datos/Catalogos/Departamentos/Departamento') AS A(departamento)


--Tipos de Documento de Identificacion
INSERT INTO TipoDocIdentidad
	SELECT
		tipodoc.value('@Id','INT') AS id,
		tipodoc.value('@Nombre','VARCHAR(40)') AS nombre,
		1 AS activo
                
	FROM @docXML.nodes('Datos/Catalogos/Tipos_de_Documento_de_Identificacion/TipoIdDoc') AS A(tipodoc)

--Tipos de Jornada
INSERT INTO TipoJornada
	SELECT
		tipoJornada.value('@Id','INT') AS id,
		tipoJornada.value('@Nombre','VARCHAR(40)') AS nombre,
		tipoJornada.value('@HoraEntrada','VARCHAR(40)') AS horaEntrada,
		tipoJornada.value('@HoraSalida','VARCHAR(40)') AS horaSalida
            
	FROM @docXML.nodes('Datos/Catalogos/TiposDeJornada/TipoDeJornada') AS A(tipoJornada)

--Tipos de Movimientos

INSERT INTO TipoMovimientoPlanilla
	SELECT
		tipoMovimiento.value('@Nombre','VARCHAR(40)') AS nombre
                
	FROM @docXML.nodes('Datos/Catalogos/TiposDeMovimiento/TipoMovimiento') AS A(tipoMovimiento)


--Feriados

INSERT INTO Feriados
	SELECT
		feriado.value('@Nombre','VARCHAR(64)') AS nombre,
		feriado.value('@Fecha','DATE') AS fecha
		
                
	FROM @docXML.nodes('Datos/Catalogos/Feriados/Feriado') AS A(feriado)


--Deducciones
CREATE TABLE #TipoDeduccionTemporal(id int,esObligatorio VARCHAR(40),esPorcentual VARCHAR(40), valor FLOAT(3));
DECLARE @count INT;
INSERT INTO TipoDeduccion
	SELECT
		tipoDeduccion.value('@Id','INT') AS id,
		tipoDeduccion.value('@Nombre','VARCHAR(40)') AS nombre,
		tipoDeduccion.value('@Obligatorio','VARCHAR(40)') AS esObligatorio,
		tipoDeduccion.value('@Porcentual','VARCHAR(40)') AS esPorcentual

	FROM @docXML.nodes('Datos/Catalogos/Deducciones/TipoDeDeduccion') AS A (tipoDeduccion)

INSERT INTO #TipoDeduccionTemporal
	SELECT
		tipoDeduccionTemp.value('@Id','INT') AS id,
		tipoDeduccionTemp.value('@Obligatorio','VARCHAR(40)') AS esObligatorio,
		tipoDeduccionTemp.value('@Porcentual','VARCHAR(40)') AS esPorcentual,
		tipoDeduccionTemp.value('@Valor','FLOAT(3)') AS valor

	FROM @docXML.nodes('Datos/Catalogos/Deducciones/TipoDeDeduccion') AS A (tipoDeduccionTemp)

SELECT @count = COUNT(*) FROM #TipoDeduccionTemporal;

				WHILE @count > 0

					BEGIN
						IF EXISTS(SELECT TOP (1) * FROM #TipoDeduccionTemporal AS TD WHERE TD.esObligatorio = 'Si')
							BEGIN
								INSERT INTO DeduccionPorcentualObligatoria
								VALUES(
								(SELECT TOP (1)  id FROM #TipoDeduccionTemporal AS TD)
								, (SELECT TOP (1) valor FROM #TipoDeduccionTemporal AS TD)
								)
							END

						DELETE TOP (1) FROM #TipoDeduccionTemporal
						SELECT @count = COUNT(*) FROM #TipoDeduccionTemporal;
					END
					 
				DROP TABLE #TipoDeduccionTemporal;



--CATALOGOS----------------------------------------------------------------

--Usuarios
/*
INSERT INTO Usuarios

	SELECT
		usuario.value('@username','VARCHAR(64)') AS username,
		usuario.value('@pwd','INT') AS pwd,
		usuario.value('@tipo','INT') AS tipo,
		1 AS activo
        
	FROM @docXML.nodes('Datos/Usuarios/Usuario') AS A(usuario);
*/

--Proceso de Operaciones--------------------------------------------------




--Se crea una tabla que va a contener una fecha y una operacion, ambos relacionados
CREATE TABLE #Operaciones(Fecha DATE,Operacion XML);

DECLARE @fechaActual DATE;
SELECT TOP 1 @fechaActual = Item.value('@Fecha','DATE')
FROM @docXML.nodes('Datos/Operacion') AS T(Item)

DECLARE @ultimaFecha DATE;
SELECT @ultimaFecha = Item.value('@Fecha','DATE')
FROM @docXML.nodes('Datos/Operacion') AS T(Item)


DECLARE @indiceNodo INT
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





--INICIO DE LA ITERACION DE OPERACION POR OPERACION

WHILE @fechaActual<=@ultimaFecha
	BEGIN
		--Se guarda en una variable de tipo XML el nodo que se va a procesar 
		--para que el acceso sea más sencillo en las operaciones
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
				-- Hacerlo en una tabla temporal para agregar uno por uno
				CREATE TABLE #EmpleadosTemp(Nombre VARCHAR(64), ValorDocumentoIdentidad INT, FechaNacimiento DATE, IdPuesto INT, IdDepartamento INT,
				IdTipoDocumentoIdentidad INT, NombreUsuario VARCHAR(64), Contraseña VARCHAR(64),Tipo INT,Activo BIT);

				INSERT INTO #EmpleadosTemp
					SELECT  
							Item.value('@Nombre','VARCHAR(64)') AS Nombre,
							Item.value('@ValorDocumentoIdentidad','INT') AS ValorDocumentoIdentidad,
							Item.value('@FechaNacimiento','DATE') AS FechaNacimiento,
							Item.value('@idPuesto','INT') AS IdPuesto,
							Item.value('@idDepartamento','INT') AS IdDepartamento,
							Item.value('@idTipoDocumentacionIdentidad','INT') AS IdTipoDocumentoIdentidad,
							Item.value('@Username','VARCHAR(64)') AS NombreUsuario,
							Item.value('@Password','VARCHAR(64)') AS Contraseña,
							1 AS Tipo,
							1 AS Activo

					FROM @nodoActual.nodes('Operacion/NuevoEmpleado') AS T(Item)

				DECLARE @countInsertar INT;
				SELECT @countInsertar = COUNT(*) FROM #EmpleadosTemp;
				WHILE @countInsertar > 0
					BEGIN
						DECLARE @Nombre Varchar(40) = (SELECT TOP(1) Nombre FROM #EmpleadosTemp)
						DECLARE @ValorDocumentoIdentidad INT =  (SELECT TOP(1) ValorDocumentoIdentidad FROM #EmpleadosTemp)
						DECLARE @FechaNacimiento DATE = (SELECT TOP(1) FechaNacimiento FROM #EmpleadosTemp)
						DECLARE @IdPuesto INT = (SELECT TOP(1) IdPuesto FROM #EmpleadosTemp)
						DECLARE @IdDepartamento INT =  (SELECT TOP(1) IdDepartamento FROM #EmpleadosTemp)
						DECLARE @IdTipoDocumentoIdentidad INT = (SELECT TOP(1) IdTipoDocumentoIdentidad FROM #EmpleadosTemp)
						DECLARE @NombreUsuario VARCHAR(64) = (SELECT TOP(1) NombreUsuario FROM #EmpleadosTemp)
						DECLARE @Contraseña VARCHAR(64) = (SELECT TOP(1) Contraseña FROM #EmpleadosTemp)

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

						DELETE TOP (1) FROM #EmpleadosTemp
						SELECT @countInsertar = COUNT(*) FROM #EmpleadosTemp;
					END
				DROP TABLE #EmpleadosTemp
			END
		
		--Insertar Tipo Jornada Proxima Semana
		
		IF ((SELECT Operacion.exist('Operacion/TipoDeJornadaProximaSemana') FROM #Operaciones WHERE Fecha = @fechaActual)=1)
			BEGIN
				INSERT INTO Jornada
					SELECT 
						tipoJornadaProximaSemana.value('@IdJornada','INT') AS idJornada,
						(SELECT E.Id FROM dbo.Empleados AS E WHERE E.ValorDocumentoIdentidad = tipoJornadaProximaSemana.value('@ValorDocumentoIdentidad','INT')),
						(SELECT IDENT_CURRENT('SemanaPlanilla'))

					FROM @nodoActual.nodes('Operacion/TipoDeJornadaProximaSemana') AS T(tipoJornadaProximaSemana)
			END
		
		--Eliminar Empleado
		
		IF ((SELECT Operacion.exist('Operacion/EliminarEmpleado') FROM #Operaciones WHERE Fecha = @fechaActual)=1)

			BEGIN

				CREATE TABLE #EliminacionesEmpleados(ValorDocIdentidad INT);
				INSERT INTO #EliminacionesEmpleados
					SELECT 
						Item.value('@ValorDocumentoIdentidad','INT') as valorDocIdentidad 
					FROM @nodoActual.nodes('Operacion/EliminarEmpleado') AS T(Item)
					
					
				DECLARE @countEliminar INT;
				SELECT @countEliminar = COUNT(*) FROM #EliminacionesEmpleados;
				
				WHILE @countEliminar>0
					BEGIN
						UPDATE dbo.Empleados
							SET 
								Empleados.Activo = 0
							WHERE 
								Empleados.ValorDocumentoIdentidad = (SELECT TOP(1) ValorDocIdentidad FROM #EliminacionesEmpleados);

						DELETE TOP (1) FROM #EliminacionesEmpleados
						SELECT @countEliminar = COUNT(*) FROM #EliminacionesEmpleados;
					END
				
				DROP TABLE #EliminacionesEmpleados;

			END
		
		/*
		--Asociar Empleado con deduccion
		IF ((SELECT Operacion.exist('Operacion/AsociaEmpleadoConDeduccion') FROM #Operaciones WHERE Fecha = @fechaActual)=1)

			BEGIN
				INSERT INTO	DeduccionXEmpleado
					SELECT
						--Fecha Inicio
						--Fecha Fin
						(SELECT Id FROM Empleados AS E WHERE E.ValorDocumentoIdentidad = AsociaDeduccion.value('@ValorDocumentoIdentidad','INT'))
						,(AsociaDeduccion.value('@IdDeduccion','INT'))

					FROM @nodoActual.nodes('Operacion/AsociaEmpleadoConDeduccion') AS T(AsociaDeduccion)
			END
		*/

		--Marcas de Asistencias
		/*
		IF ((SELECT Operacion.exist('Operacion/MarcaDeAsistencia') FROM #Operaciones WHERE Fecha = @fechaActual)=1)
			BEGIN
				CREATE TABLE #MarcasAux (FechaInicio SMALLDATETIME,FechaFin SMALLDATETIME,IdJornada INT);
				INSERT INTO #MarcasAux
					SELECT
						marcaAsistencia.value('@FechaEntrada','SMALLDATETIME') AS fechaEntrada,
						marcaAsistencia.value('@FechaSalida','SMALLDATETIME') AS fechaSalida,
						(SELECT TOP 1 J.id 
						FROM dbo.Jornada AS J 
						WHERE J.IdEmpleado IN (SELECT TOP 1 E.Id 
												FROM dbo.Empleados AS E 
												WHERE E.ValorDocumentoIdentidad = marcaAsistencia.value('@ValorDocumentoIdentidad','INT')))

					FROM @nodoActual.nodes('Operacion/MarcaDeAsistencia') AS T(marcaAsistencia)

				DECLARE @countMarcasAux INT;
				SELECT @countMarcasAux = COUNT(*) FROM #MarcasAux;

				WHILE @countMarcasAux>0
					BEGIN
						DECLARE @fechaInicio SMALLDATETIME =  CONVERT(TIME,(SELECT TOP(1) FechaInicio FROM #MarcasAux));
						DECLARE @fechaFin SMALLDATETIME =  CONVERT(TIME,(SELECT TOP(1) FechaFin FROM #MarcasAux));
						DECLARE @idJornada INT = (SELECT TOP(1) IdJornada FROM #MarcasAux);
						DECLARE @idEmpleado INT = (SELECT IdEmpleado FROM Jornada WHERE Jornada.Id = @idJornada);
						DECLARE @horasTrabajadas INT = DATEDIFF(HOUR,@fechaInicio,@fechaFin); --Calcula las horas trabajadas en la sesion
						DECLARE @horaFinNormal TIME;
						DECLARE @idTipoJornada INT = (SELECT Jornada.IdTipoJornada FROM Jornada WHERE  Id =  @idJornada );
						DECLARE	@horasExtra INT = 0; DECLARE @horasExtrasDoble INT = 0; DECLARE @ganancias INT = 0;
						DECLARE @salarioXHora INT = (
													SELECT SalarioXHora FROM Puestos WHERE Puestos.Id = (SELECT IdPuesto FROM Empleados WHERE Empleados.Id = @idEmpleado)
													);
						SELECT @horaFinNormal = (
							CONVERT(
								SMALLDATETIME,
								(SELECT HoraFin FROM TipoJornada WHERE Id = @idTipoJornada)  
								)
						);

						IF (DATEPART(WEEKDAY,@fechaActual) = 7) OR (@fechaActual IN (SELECT Fecha FROM Feriados)) --Si es domingo o la fecha es un feriado son horas extra dobles
							BEGIN
								SELECT @horasExtrasDoble = DATEDIFF(HOUR,@horaFinNormal,@fechaFin); 
							END
						SELECT @horasExtra = DATEDIFF(HOUR,@horaFinNormal,@fechaFin);
						IF @horasExtrasDoble>0
							BEGIN
								SELECT @horasExtra = 0;
							END
						SELECT @horasTrabajadas = @horasTrabajadas-@horasExtra-@horasExtrasDoble;

						SELECT @ganancias = (@salarioXHora*@horasTrabajadas) + (@salarioXHora*1.5*@horasExtra) + (@salarioXHora*2*@horasExtrasDoble);
						
						INSERT INTO dbo.MarcaDeAsistencia
							VALUES
							(
							@fechaInicio,
							@fechaFin,                             
							@idJornada
							)
						IF @horasExtra = 0 AND @horasExtrasDoble = 0
							BEGIN 
								INSERT INTO dbo.MovimientoPlanilla
								VALUES
								(
								@fechaActual,
								@ganancias,
								1,
								(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado )
								)

							END

						IF @horasExtra>0 AND @horasExtrasDoble = 0
							BEGIN
								INSERT INTO dbo.MovimientoPlanilla
								VALUES
								(
								@fechaActual,
								@ganancias,
								2,
								(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado )
								)
							END

						IF @horasExtrasDoble>0 AND @horasExtra = 0
							BEGIN
								INSERT INTO dbo.MovimientoPlanilla
								VALUES
								(
								@fechaActual,
								@ganancias,
								3,
								(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado )
								)
							END
						


						SELECT @idTipoJornada,@horasTrabajadas,@horasExtra,@horasExtrasDoble,@salarioXHora,@ganancias;
						DELETE TOP(1) FROM #MarcasAux
						SELECT @countMarcasAux = COUNT(*) FROM #MarcasAux;
					END
				DROP TABLE #MarcasAux
				
				
			END
			*/

			 
		--Iterador 
		SET @fechaActual =  DATEADD(DAY,1,@fechaActual);
		
	END
	 



DROP TABLE #Operaciones	
--DROP TABLE #MarcasAux
--DROP TABLE #EmpleadosTemp






	
