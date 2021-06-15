
CREATE FUNCTION CargarXML( )
	RETURNS XML

	BEGIN
		DECLARE @docXML XML = (
		SELECT * FROM(
			SELECT CAST(c AS XML) FROM
			OPENROWSET(
				BULK 'C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea3.xml',SINGLE_BLOB) AS T(c)
			) AS S(C)
		)
		
		RETURN @docXML;
	END

/*
Path del archivo XML
C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\III-Proyecto-Bases\SQL\Datos_Tarea3.xml
C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea3.xml
*/