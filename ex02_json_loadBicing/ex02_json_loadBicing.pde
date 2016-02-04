HashMap<Integer, Station> stationsMap = new HashMap<Integer, Station>();
import java.util.Map;
 
void setup() {
  size(800, 600);
  background(0);
  String jsonContent[] = loadStrings("http://wservice.viabicing.cat/v2/stations");
  JSONObject json = JSONObject.parse(jsonContent[0]);
  
  JSONArray stations = json.getJSONArray("stations");
  
  for (int i = 0; i < stations.size() ; i++) {
    JSONObject station = stations.getJSONObject(i);
    Station newStation = new Station();
    newStation.electric = "BIKE".equals(station.getString("tyfope"));
    newStation.streetName = station.getString("streetName");
    newStation.slots = station.getInt("slots");
    newStation.bikes = station.getInt("bikes");
    newStation.altitude = station.getInt("altitude");
    newStation.streetNumber = station.getString("streetNumber");
    newStation.latitude = station.getFloat("latitude");
    newStation.longitude = station.getFloat("longitude");
    String nearbyStations = station.getString("nearbyStations");
    newStation.nearbyStations = new IntList();
    for (int j = 0 ; j < nearbyStations.split(",").length; j++){
      newStation.nearbyStations.append(Integer.parseInt(trim(nearbyStations.split(",")[j])));
    }
    stationsMap.put(station.getInt("id"), newStation);
  }
  
  for (Map.Entry<Integer, Station> station : stationsMap.entrySet()) {
    int id = station.getKey();
    Station sta = station.getValue();
    println("There are " + sta.bikes + " bikes in " + sta.streetName + ", " + sta.streetNumber); 
  }
}
 
void draw() {
}

class Station {
  String streetName, streetNumber;
  int slots, bikes, altitude;
  float latitude, longitude;
  boolean electric, status;
  IntList nearbyStations;
}