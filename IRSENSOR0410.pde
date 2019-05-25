
    // Connect extra wires to GND, 3.3v, and AO (output from transistor)
    
    import processing.serial.*;
    import de.bezier.data.sql.*;
    Serial myPort; // The serial port
    PrintWriter output;
    int xPos = 1; // horizontal position of the graph
    //float oldHeartrateHeight = 0; // for storing the previous reading
    float[] gsrs = new float[600];
    float[] heartrates = new float[600];

    void setup () {
    // set the window size:
    size(600, 400);
    frameRate(25);

    output = createWriter( "data.csv" );
    output.println("GSR, IR");
    
    // List available serial ports.
    //println(Serial.list());

    // Setup which serial port to use.
    // This line might change for different computers.
    // Set based on the serial.list output 
    myPort = new Serial(this, "/dev/cu.usbmodem14401", 9600);
    myPort.clear();
    // set inital background:
    background(0);
    }

    void draw () {
      background(0);
      stroke(255,255,255);
      line(0, height/2, width, height/2);
      stroke(0,255,0);
      for (int i=1; i < xPos; i++) {
        line(i - 1, height - gsrs[i-1], i, height - gsrs[i]);
      }
      stroke(255,0,0);
      for (int i=1; i < xPos; i++) {
        line(i - 1, height - heartrates[i-1], i, height - heartrates[i]);
      }
      //println("GSR: " + (gsrs[xPos - 1]));
      //println("Heart: " + (heartrates[xPos - 1]));
    }

    void serialEvent (Serial myPort) {
    // read the string from the serial port.
    //String gsrString = myPort.readStringUntil('\n');
    //println("G: " + gsrString);
    String inString = myPort.readStringUntil('\n');
    
    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // convert to an int
      output.println(inString);
      String[] strInputs = split(inString, ',');
      println(strInputs);
      int[] intInputs = {0,0};
      for (int i = 0; i < 2; i++) {
        intInputs[i] = int(strInputs[i]);
      }
      
      //map values and put in arrays to be used in draw()
      float gsrHeight = map(intInputs[0], 100, 600, 0, height/2);
      gsrs[xPos] = gsrHeight;
      float heartrateHeight = map(intInputs[1], 100, 600, height/2, height);
      heartrates[xPos] = heartrateHeight;
      xPos++;
        
      // at the edge of the screen, go back to the beginning:
      if (xPos >= width) {
        xPos = 1;
        background(0);
      }
    }
    output.flush();
  }