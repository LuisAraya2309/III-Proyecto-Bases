USE [SistemaObrero]
--TABLAS
delete from MarcaDeAsistencia;
delete from FijaNoObligatoria;
delete from DeduccionXEmpleadoNoObligatoriaPorcentual;
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
delete from DetalleCorrida;
delete from Corrida;
delete from BitacoraErrores;
delete from MovimientoDeHoras;
delete from MovimientoDeduccion;
delete from DeduccionXEmpleadoXMes;
delete from MovimientoPlanilla;
delete from Usuarios;
DELETE FROM TipoMovimientoPlanilla
delete from Historial;

--IDENTITY
DBCC CHECKIDENT ('Empleados', RESEED, 0)
DBCC CHECKIDENT ('MarcaDeAsistencia', RESEED, 0)
DBCC CHECKIDENT ('Jornada', RESEED, 0)
DBCC CHECKIDENT ('SemanaPlanilla', RESEED, 0)
DBCC CHECKIDENT ('MesPlanilla', RESEED, 0)
DBCC CHECKIDENT ('DeduccionXEmpleado', RESEED, 0)
DBCC CHECKIDENT ('DeduccionXEmpleadoXMes', RESEED, 0)
DBCC CHECKIDENT ('PlanillaXSemanaXEmpleado', RESEED, 0)
DBCC CHECKIDENT ('PlanillaXMesxEmpleado', RESEED, 0)
DBCC CHECKIDENT ('Corrida', RESEED, 0)
DBCC CHECKIDENT ('DetalleCorrida', RESEED, 0)
DBCC CHECKIDENT ('BitacoraErrores', RESEED, 0)
DBCC CHECKIDENT ('MovimientoPlanilla', RESEED, 0)
DBCC CHECKIDENT ('TipoMovimientoPlanilla', RESEED, 0)
DBCC CHECKIDENT ('Usuarios', RESEED, 0)
DBCC CHECKIDENT ('Historial', RESEED, 0)
--STORED PROCEDURES
/*DROP PROCEDURE sp_InsertarTipoJornadaProximaSemana*/

