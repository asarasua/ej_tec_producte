import http.requests.*;
import java.util.Date;
import java.util.Map;

HashMap<Integer, Prediccion> predicciones = new HashMap<Integer, Prediccion>();
XML xml;

void setup() {
  size(400,400);
  smooth();
  
  GetRequest get = new GetRequest("http://static-m.meteo.cat/content/opendata/ctermini_comarcal.xml");
  get.send(); 
  
  try {
    xml = XML.parse(get.getContent());
  } catch (Exception e) {
    println("XML could not be parsed.");
  }  
    
  for (int i = 0; i < xml.getChildren().length ; i++) {
    XML nodo = xml.getChildren()[i];
    if("comarca".equals(nodo.getName())){
      Prediccion nuevaPrediccion = new Prediccion();
      nuevaPrediccion.nombreComarca = nodo.getString("nomCOMARCA");
      nuevaPrediccion.nombreCapital = nodo.getString("nomCAPITALCO");      
      predicciones.put(nodo.getInt("id"), nuevaPrediccion);
    } else if("prediccio".equals(nodo.getName())){
      int idComarca = nodo.getInt("idcomarca");
      if (predicciones.get(idComarca) != null){
        predicciones.get(idComarca).tempMinHoy = nodo.getChild(0).getInt("tempmin");
        predicciones.get(idComarca).tempMaxHoy = nodo.getChild(0).getInt("tempmax");
        predicciones.get(idComarca).tempMinManana = nodo.getChild(1).getInt("tempmin");
        predicciones.get(idComarca).tempMaxManana = nodo.getChild(1).getInt("tempmax");
      }
    }
  }
  
  for (Map.Entry<Integer, Prediccion> prediccion : predicciones.entrySet()) {
    int id = prediccion.getKey();
    Prediccion pred = prediccion.getValue();
    println("Hoy en " + pred.nombreComarca + " hay una minima de " + str(pred.tempMinHoy)); 
  }

}
  

class Prediccion {
  String nombreComarca, nombreCapital;
  Date fecha;
  int tempMinHoy, tempMaxHoy, tempMinManana, tempMaxManana;  
}