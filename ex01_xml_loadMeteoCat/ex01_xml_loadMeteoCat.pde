import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Map;

HashMap<Integer, Prediction> predictions = new HashMap<Integer, Prediction>();
XML xml;

void setup() {
  SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
  size(400, 400);
  smooth();

  String xmlContent[] = loadStrings("http://static-m.meteo.cat/content/opendata/ctermini_comarcal.xml");

  try {
    xml = XML.parse(xmlContent[0]);
  } 
  catch (Exception e) {
    println("XML could not be parsed.");
  }  

  for (int i = 0; i < xml.getChildren().length; i++) {
    XML nodo = xml.getChildren()[i];
    if ("comarca".equals(nodo.getName())) {
      Prediction newPrediction = new Prediction();
      newPrediction.nameRegion = nodo.getString("nomCOMARCA");
      newPrediction.nameCapital = nodo.getString("nomCAPITALCO");      
      predictions.put(nodo.getInt("id"), newPrediction);
    } else if ("prediccio".equals(nodo.getName())) {
      int idRegion = nodo.getInt("idcomarca");
      if (predictions.get(idRegion) != null) {
        try {
          predictions.get(idRegion).date = formatter.parse(nodo.getChild(0).getString("data"));
        } 
        catch(Exception e) {
          println(e.getMessage());
        }        
        predictions.get(idRegion).tempMinTod = nodo.getChild(0).getInt("tempmin");
        predictions.get(idRegion).tempMaxTod = nodo.getChild(0).getInt("tempmax");
        predictions.get(idRegion).tempMinTom = nodo.getChild(1).getInt("tempmin");
        predictions.get(idRegion).tempMaxTom = nodo.getChild(1).getInt("tempmax");
      }
    }
  }

  for (Map.Entry<Integer, Prediction> prediction : predictions.entrySet()) {
    int id = prediction.getKey();
    Prediction pred = prediction.getValue();
    println("Today in " + pred.nameRegion + " the min temperature is " + str(pred.tempMinTod));
  }
}  

class Prediction {
  String nameRegion, nameCapital;
  Date date;
  int tempMinTod, tempMaxTod, tempMinTom, tempMaxTom;
}