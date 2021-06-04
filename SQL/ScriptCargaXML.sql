
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
INSERT INTO Usuarios

	SELECT
		usuario.value('@username','VARCHAR(64)') AS username,
		usuario.value('@pwd','INT') AS pwd,
		usuario.value('@tipo','INT') AS tipo,
		1 AS activo
        
	FROM @docXML.nodes('Datos/Usuarios/Usuario') AS A(usuario);












	
