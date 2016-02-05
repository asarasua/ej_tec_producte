/*
  Ejemplo de lectura de un JSON
 Lee los datos de previsión las estaciones de Bicing (http://wservice.viabicing.cat/v2/stations) y los almacena en un mapa
 
 Álvaro Sarasúa
 */
 //Importamos Map para poder utilizar HashMap
import java.util.Map;
//HashMap (https://processing.org/reference/HashMap.html) es una clase específica de Java-Processing, pero tiene equivalentes en prácticamente todos los lenguajes.
//Permite crear un "mapa", una lista de pares clave-valor (key-value). En este caso, el key es el id (un entero) y el value un objeto de la clase Station
HashMap<Integer, Station> stationsMap = new HashMap<Integer, Station>();
 
void setup() {
  size(800, 600);
  background(0);
  
  //https://processing.org/reference/loadStrings_.html
  String jsonContent[] = loadStrings("http://wservice.viabicing.cat/v2/stations");
  
  //Creamos un objeto de la clase JSONObject parseando el fichero json de la web
  JSONObject json = JSONObject.parse(jsonContent[0]);
  
  //JSONArray es un array de objetos JSONObject. 
  //En XML eran todos los del mismo nombre. En JSON, tenemos "stations": [.., .., ..]
  //Es decir, el key "stations" tiene un value que es una lista/array. Eso es lo que leemos
  JSONArray stations = json.getJSONArray("stations");
  
  for (int i = 0; i < stations.size() ; i++) {
    //Cada elemento de la lista tiene un conjunto de pares key-value dentro de llaves {} y en la forma key:value
    //por ejemplo: "id":"1","type":"BIKE","latitude":"41.397952"
    JSONObject station = stations.getJSONObject(i);
    Station newStation = new Station();
    newStation.electric = "BIKE-ELECTRIC".equals(station.getString("type"));
    newStation.open = "OPN".equals(station.getString("status"));
    newStation.streetName = station.getString("streetName");
    newStation.slots = station.getInt("slots");
    newStation.bikes = station.getInt("bikes");
    newStation.altitude = station.getInt("altitude");
    newStation.streetNumber = station.getString("streetNumber");
    newStation.latitude = station.getFloat("latitude");
    newStation.longitude = station.getFloat("longitude");
    //Para leer las estaciones cercanas
    //las cargamos a un String
    String nearbyStations = station.getString("nearbyStations");
    //inicializamos la lista
    newStation.nearbyStations = new IntList();
    //Separamos el string en trozos separando con ","
    //p ej: "24, 369, 387, 426" -> ["24"][" 369"][" 387"][" 426"]
    String[] stringParts = nearbyStations.split(",");
    for (int j = 0 ; j < stringParts.length; j++){
      //trim elimina espacios a principio y final, parseInt convierte string en un int
      newStation.nearbyStations.append(Integer.parseInt(trim(stringParts[j])));
    }
    stationsMap.put(station.getInt("id"), newStation);
  }
}
 
void draw()
{
  fill(0);
  rect(0, 0, width, height); 

  fill(200);
  for (Map.Entry<Integer, Station> mapElement : stationsMap.entrySet()) {
    int id = mapElement.getKey();
    Station station = mapElement.getValue();
    text("There are " + station.bikes + " bikes in " + station.streetName + ", " + station.streetNumber, 20, 10 + height / 30 * id, 400, 200);
  }

  delay(1000);
}

class Station {
  String streetName, streetNumber;
  int slots, bikes, altitude;
  float latitude, longitude;
  boolean electric, open;
  IntList nearbyStations;
}