
package validaciones;

import java.sql.Connection;
import java.sql.SQLException;
import conexion.conexionBD;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class validacionesSQL {
    public static boolean existePuesto(String puesto){
            try{ 

                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarPuestos";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                List<String> puestosConvertidos = new ArrayList<>();
                while(dataset.next()){
                   puestosConvertidos.add(dataset.getString("Nombre"));
                }
                for(int i=0;i<puestosConvertidos.size();i++){
                    if(puesto.equals(puestosConvertidos.get(i))){
                        return true;
                    }
                }
                return false;

            }catch(SQLException ex){
               return false;
            } 
}
 public static boolean existePuestoID(String id){
            try{ 

                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarPuestos";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                List<String> puestosConvertidos = new ArrayList<>();
                while(dataset.next()){
                   puestosConvertidos.add(dataset.getString("id"));
                }
                for(int i=0;i<puestosConvertidos.size();i++){
                    if(id.equals(puestosConvertidos.get(i))){
                        return true;
                    }
                }
                return false;

            }catch(SQLException ex){
               return false;
            } 
}
    public static boolean existeEmpleado(String empleado){
            try{ 

                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();
                    String callSP = "EXECUTE sp_ListarEmpleados";
                    PreparedStatement ps = conexion.prepareStatement(callSP);
                    ResultSet dataset = ps.executeQuery();
                    List<String> empleadosConvertidos = new ArrayList<>();
                    while(dataset.next()){
                       empleadosConvertidos.add(dataset.getString("ValorDocumentoIdentidad"));
                    }
     
                    for(int i=0;i<empleadosConvertidos.size();i++){
                        
                        if(empleado.equals(empleadosConvertidos.get(i))){
                            return true;
                        }
                    }
                    return false;

                }catch(SQLException ex){
                   return false;
                } 
    }
    
     public static boolean existeEmpleadoNombre(String empleado){
            try{ 

                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();
                    String callSP = "EXECUTE sp_ListarEmpleados";
                    PreparedStatement ps = conexion.prepareStatement(callSP);
                    ResultSet dataset = ps.executeQuery();
                    List<String> empleadosConvertidos = new ArrayList<>();
                    while(dataset.next()){
                       empleadosConvertidos.add(dataset.getString("Nombre"));
                    }
                    for(int i=0;i<empleadosConvertidos.size();i++){
                        
                        if(empleado.equals(empleadosConvertidos.get(i))){
                            return true;
                        }
                    }
                    return false;

                }catch(SQLException ex){
                   return false;
                } 
    }
    
     public static boolean existeEmpleadoPuesto(String puesto){
            try{ 

                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();
                    String callSP = "EXECUTE sp_ListarEmpleados";
                    PreparedStatement ps = conexion.prepareStatement(callSP);
                    ResultSet dataset = ps.executeQuery();
                    List<String> empleadosConvertidos = new ArrayList<>();
                    while(dataset.next()){
                       empleadosConvertidos.add(dataset.getString(5));
                    }
                    for(int i=0;i<empleadosConvertidos.size();i++){
                        if(puesto.equals(empleadosConvertidos.get(i))){
                            return true;
                        }
                    }
                    return false;

                }catch(SQLException ex){
                   return false;
                } 
    }
    
    public static boolean validarFecha(String fecha){
        /*
        String[] splittedFecha = fecha.split("-");
        if(splittedFecha.length!=3){
            try{
                int año = Integer.parseInt(splittedFecha[0]);
                int mes = Integer.parseInt(splittedFecha[1]);
                int dia = Integer.parseInt(splittedFecha[2]);
                boolean diaC = (1<=dia)&&(dia<=31);
                boolean mesC = (1<=mes)&&(mes<=12);
                boolean añoC = (año<=2021)&&(0<año);
                return (diaC&&mesC&&añoC);
                
            }catch(NumberFormatException e){
                return false;
            }
        }
        else{
            return false;
        }
    */
        return true;
    }
    
    public static boolean validLogin(String user,String password){
            try{ 
                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarUsuarios";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                HashMap<String, String> usuarios = new HashMap<>();
                while(dataset.next()){
                   usuarios.put(dataset.getString("username"),dataset.getString("pwd"));
                }
                if(usuarios.containsKey(user)){
                    return usuarios.get(user).equals(password);
                }
                else{
                    return false;
                }

            }catch(SQLException ex){
               return false;
            } 
    }
}
