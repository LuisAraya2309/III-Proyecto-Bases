
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" /> 
        <title>Editar Puestos</title>
    </head>
    <body>
        <form action="puestoAEditar.jsp">
            <% String puestoSeleccionado  = request.getParameter("puesto");
                String puestoActualizado =""; 
                if(puestoSeleccionado!=null){
                    String[] infoPuesto = puestoSeleccionado.split(" ");
                    puestoActualizado = infoPuesto[1]; 
                }
                else{
                puestoActualizado = "";
                }
            %>
            Puesto a editar: <input type="text" name="puestoEditar" value="<%= puestoActualizado%>" required="">
            Nuevo Id: <input type="text" name="nuevoId" required=""> 
            Nuevo nombre: <input type="text" name="nuevoNombre" required=""> 
            Nuevo salario: <input type="text" name="nuevoSalario" required=""> 
            <input type="submit" name="editar" id="editar" value="Editar">
        </form>
        <a href='central.html'>Regresar a la central</a>
    </body>
</html>
