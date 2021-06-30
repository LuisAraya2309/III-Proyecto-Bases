
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="conexion.conexionBD"%>
<%@page import="conexion.conexionBD"%>
<%@page import="java.util.HashMap"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Decidir Funcionalidad</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href = "styleCentral.css" type = "text/css"  rel = "stylesheet" />
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
    </head>
    <body>
        
        <%
             HashMap<String, String> funcionalidades = new HashMap<>();
             
             //Llenar el hash
             funcionalidades.put("Historial", "historial.jsp");
             funcionalidades.put("Editar Empleado", "editarEmpleados.jsp");
             funcionalidades.put("Editar Deducciones", "editarDeduccion.jsp");
             funcionalidades.put("Ver Planillas Semanales", "planillaSemanal.jsp");
             funcionalidades.put("Ver Planillas Mensuales", "planillaMensual.jsp");
             request.setAttribute("infoEmpleado", new String(request.getParameter("empleados")));    
             request.getRequestDispatcher(funcionalidades.get(request.getParameter("funcionalidad"))).forward(request, response);
        %>
    </body>
</html>
