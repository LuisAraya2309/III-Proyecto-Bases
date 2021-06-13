USE [SistemaObrero]
--TABLAS
delete from MarcaDeAsistencia;
delete from DeduccionXEmpleado;
delete from Jornada;
delete from Empleados;
delete from Departamento;
delete from Puestos;
delete from DeduccionPorcentualObligatoria;
delete from TipoDeduccion;
delete from TipoDocIdentidad;
delete from TipoJornada;
delete from SemanaPlanilla;
delete from MesPlanilla;
delete from Feriados;
delete from Errores
delete from PlanillaXSemanaxEmpleado;
delete from PlanillaXMesxEmpleado;

--IDENTITY
DBCC CHECKIDENT ('Empleados', RESEED, 0)
DBCC CHECKIDENT ('MarcaDeAsistencia', RESEED, 0)
DBCC CHECKIDENT ('Jornada', RESEED, 0)
DBCC CHECKIDENT ('SemanaPlanilla', RESEED, 0)
DBCC CHECKIDENT ('MesPlanilla', RESEED, 0)
DBCC CHECKIDENT ('PlanillaXSemanaXEmpleado', RESEED, 0)
DBCC CHECKIDENT ('PlanillaXMesxEmpleado', RESEED, 0)

--STORED PROCEDURES
/*DROP PROCEDURE sp_InsertarTipoJornadaProximaSemana*/

