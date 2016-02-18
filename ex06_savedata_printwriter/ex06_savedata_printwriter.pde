  
PrintWriter output;
int counter;

void setup() {
  output = createWriter("data/new.csv");
  output.println("timeStamp,randomNumbers,growingNumbers");
  counter = 0;
}

void draw() {
  output.println( str(millis()) + "," + str(random(-5, 5)) + "," + str(counter) );
  counter++;
  delay(300);
}

void keyPressed() {
  if (key == 'A' || key =='a'){
    exit();
  }
}