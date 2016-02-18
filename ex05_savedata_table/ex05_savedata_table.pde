  
Table table;
int counter;

void setup() {

  table = new Table();
  
  table.addColumn("timeStamp");
  table.addColumn("randomNumbers");
  table.addColumn("growingNumbers");
  
  counter = 0;
}

void draw() {
  TableRow newRow = table.addRow();
  newRow.setInt("timeStamp", millis());
  newRow.setInt("growingNumbers", counter);
  newRow.setFloat("randomNumbers", random(-5, 5));
  counter++;
  delay(300);
}

void keyPressed() {
  if (key == 'A' || key =='a'){
    saveTable(table, "data/new.csv");
    exit();
  }
}