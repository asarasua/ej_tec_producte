/*
  Ejemplo de lectura de un XML
 Lee los datos de previsión metereológica de MeteoCat (http://static-m.meteo.cat/content/opendata/ctermini_comarcal.xml) y los almacena en un mapa
 
 Álvaro Sarasúa
 */

//Importamos Date para poder almacenar la fecha y SimpleDateFormat para leer la fecha desde el XML
import java.util.Date;
import java.text.SimpleDateFormat;
//Importamos Map para poder utilizar HashMap
import java.util.Map;

//HashMap (https://processing.org/reference/HashMap.html) es una clase específica de Java-Processing, pero tiene equivalentes en prácticamente todos los lenguajes.
//Permite crear un "mapa", una lista de pares clave-valor (key-value). En este caso, el key es el id (un entero) y el value un objeto de la clase Prediction
HashMap<Integer, Prediction> predictions = new HashMap<Integer, Prediction>();
//XML es una clase que permite parsear archivos xml; instanciamos una variable de esta clase para leer nuestro xml
XML xml;

void setup() {
  //Nuestro formatter lee fechas en el formato que le digamos. dd-MM-yyyy es el formato en el xml que vamos a leer
  SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
  size(400, 400);
  smooth();

  //https://processing.org/reference/loadStrings_.html
  String xmlContent[] = loadStrings("http://static-m.meteo.cat/content/opendata/ctermini_comarcal.xml"); 
  //para seguir mejor el ejemplo es recomendable abrir la url en el navegador y ver el contenido que vamos a leer

  //Hay funciones (como parse) que pueden lanzar excepciones si algo va mal. En ese caso tenemos que hacer try-catch; si hay excepción es ejecuta el código dentro del "catch"
  try {
    xml = XML.parse(xmlContent[0]);
  } 
  catch (Exception e) {
    println("XML could not be parsed.");
  }  

  //getChildren() devuelve todos los nodos hijos del ***nodo actual*** con el nombre que le pasemos como argumento
  //Si no pasamos ningún nombre como argumento lee todos los hijos

  //1 - Recorremos los hijos de nombre "comarca"
  for (int i = 0; i < xml.getChildren("comarca").length; i++) {
    XML nodo = xml.getChildren("comarca")[i];
    //Instanciamos un nuevo objeto de la clase Prediction
    Prediction newPrediction = new Prediction();
    //Leemos los datos, en este caso 2 strings
    newPrediction.nameRegion = nodo.getString("nomCOMARCA");
    newPrediction.nameCapital = nodo.getString("nomCAPITALCO");
    //Metemos el elemento en el mapa. El key es el id (un entero), el value es el objeto recién creado
    predictions.put(nodo.getInt("id"), newPrediction);
  }

  //2 - Recorremos los hijos de nombre "prediccio"
  for (int i = 0; i < xml.getChildren("prediccio").length; i++) {
    XML nodo = xml.getChildren("prediccio")[i];
    //leemos el id de la comarca para esta predicción
    int idRegion = nodo.getInt("idcomarca");

    //Comprobamos que hay un elemento en nuestro mapa con ese id
    if (predictions.get(idRegion) != null) {
      //Leemos los datos
      //fecha
      try {
        predictions.get(idRegion).date = formatter.parse(nodo.getChild(0).getString("data"));
      } 
      catch(Exception e) {
        println(e.getMessage());
      }
      //Para leer las temperaturas, cada nodo "prediccio" tiene 2 hijos con las previsiones de hoy y mañana
      predictions.get(idRegion).tempMinTod = nodo.getChild(0).getInt("tempmin");
      predictions.get(idRegion).tempMaxTod = nodo.getChild(0).getInt("tempmax");
      predictions.get(idRegion).tempMinTom = nodo.getChild(1).getInt("tempmin");
      predictions.get(idRegion).tempMaxTom = nodo.getChild(1).getInt("tempmax");
    }
  }
}  

void draw()
{
  fill(0);
  rect(0, 0, width, height); 

  fill(200);
  for (Map.Entry<Integer, Prediction> prediction : predictions.entrySet()) {
    int id = prediction.getKey();
    Prediction pred = prediction.getValue();
    text("Today in " + pred.nameRegion + " the min temperature is " + str(pred.tempMinTod), 20, 10 + height / 30 * id, 400, 200);
  }
  delay(10000);
}

//Clase para almacenar los datos de una predicción
class Prediction {
  String nameRegion, nameCapital;
  Date date;
  int tempMinTod, tempMaxTod, tempMinTom, tempMaxTom;
}