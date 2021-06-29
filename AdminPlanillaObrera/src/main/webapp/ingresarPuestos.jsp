
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" /> 
        <title>Ingresar Puesto</title>
    </head>
    <body>
        <form action="puestoAIngresar.jsp">
            Nuevo Id: <input type="text" name="nuevoId" required=""> 
            Nuevo nombre: <input type="text" name="nuevoNombre" required=""> 
            Nuevo salario: <input type="text" name="nuevoSalario" required=""> 
            <input type="submit" name="ingresar" id="ingresar" value="Ingresar">
        </form>
        <a href='central.html'>Regresar a la central</a>
    </body>
</html>
