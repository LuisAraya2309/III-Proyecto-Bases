USE [SistemaObrero]
delete from MarcasAsistencias;
delete from DeduccionXEmpleado;
delete from Jornada;
delete from Empleados;
delete from Departamento;
delete from Puestos;
delete from DeduccionPorcentualObligatoria;
delete from TipoDeduccion;
delete from TipoDocIdentidad;
--delete from Usuarios;
delete from TipoJornada;
delete from SemanaPlanilla;
delete from MesPlanilla;
delete from Feriados;
delete from Errores 
/*DROP PROCEDURE sp_CargarPuestos;
DROP PROCEDURE sp_CargarDepartamentos;
DROP PROCEDURE sp_CargarTipoDocIdentidad;
DROP PROCEDURE sp_CargarTipoJornada;
DROP PROCEDURE sp_CargarTipoMovimientoPlanilla;
DROP PROCEDURE sp_CargarFeriados;
DROP PROCEDURE sp_CargarTipoDeduccion;
DROP PROCEDURE sp_CargarUsuarios;
DROP PROCEDURE sp_CargarEmpleados;
DROP PROCEDURE sp_CargarMesesSemanas;
DROP PROCEDURE sp_CargarTipoJornadaProximaSemana;
DROP PROCEDURE sp_CargarMarcasAsistencia;
DROP PROCEDURE sp_CargarEliminarEmpleados;
DROP TABLE Errores */
DBCC CHECKIDENT ('Empleados', RESEED, 0)
DBCC CHECKIDENT ('MarcasAsistencias', RESEED, 0)
DBCC CHECKIDENT ('Jornada', RESEED, 0)
DBCC CHECKIDENT ('SemanaPlanilla', RESEED, 0)
DBCC CHECKIDENT ('MesPlanilla', RESEED, 0)
