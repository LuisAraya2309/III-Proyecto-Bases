CREATE VIEW VistaImplementada
AS
	SELECT
		Dep.Nombre AS NombreDepartamento,
		AVG(PlanillaMes.SalarioBruto) AS PromedioSalarioNeto,
		SUM(PlanillaMes.SalarioBruto) - SUM(PlanillaMes.SalarioNeto) AS TotalDeducciones,
		MAX(PlanillaMes.SalarioNeto) AS SalarioMaximo,
		(SELECT Pl.IdEmpleado FROM PlanillaXMesXEmpleado Pl WHERE Pl.SalarioNeto = MAX(PlanillaMes.SalarioNeto)) AS IdEmpleado
	FROM PlanillaXMesxEmpleado PlanillaMes
	INNER JOIN Empleados Emp
	ON Emp.Id = PlanillaMes.IdEmpleado
	INNER JOIN Departamento Dep
	ON Dep.Id = Emp.IdDepartamento
	GROUP BY Dep.Nombre