USE SistemaObrero;
SET LANGUAGE SPANISH;

DECLARE @docXML XML = (
SELECT * FROM(
	SELECT CAST(c AS XML) FROM
	OPENROWSET(
		BULK 'C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea2.xml',SINGLE_BLOB) AS T(c)
	) AS S(C)
)

-- C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml
	-- C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL


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
		feriado.value('@Fecha','VARCHAR(64)') AS fecha,
		feriado.value('@Nombre','VARCHAR(64)') AS nombre
                
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

WHILE @fechaActual<= @ultimaFecha
	BEGIN
		--Se guarda en una variable de tipo XML el nodo que se va a procesar 
		--para que el acceso sea más sencillo en las operaciones
		DECLARE @nodoActual XML;
		SELECT @nodoActual = CONVERT(XML,Operacion)
		FROM
		#Operaciones WHERE Fecha = @fechaActual;

		--Se verifica si la fecha corresponde a cierre de semana y cambio de mes
		IF DATEPART(WEEKDAY,@fechaActual) = 4   --Esto es si es jueves
			BEGIN
				IF (DATENAME(MONTH,@fechaActual)) <>(DATENAME(MONTH,DATEADD(DAY,-7,@fechaActual))) 

					INSERT INTO dbo.MesPlanilla
						VALUES((SELECT DATEADD(DAY,1,@fechaActual)),(SELECT DATEADD(MONTH,1,@fechaActual)))

					INSERT INTO dbo.SemanaPlanilla
						VALUES(@fechaActual,(SELECT DATEADD(WEEK,1,@fechaActual)),(SELECT MAX(Id) AS id FROM MesPlanilla))
			END

		

		--Se empieza a ejecutar la accion dependiendo del tag


		--Agregar nuevo empleado
		
		IF ((SELECT Operacion.exist('Operacion/NuevoEmpleado') FROM #Operaciones WHERE Fecha = @fechaActual)=1)
			BEGIN
				INSERT INTO dbo.Empleados

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



		--Iterador 
		SET @fechaActual =  DATEADD(DAY,1,@fechaActual);

	END

DROP TABLE #Operaciones








	
