import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial myPort; 
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;

void setup() {
  size(1000, 600); 
  smooth();
  myPort = new Serial(this, "COM9", 9600); // Change COM port accordingly
  myPort.bufferUntil('.');// Reads data from the serial port up to '.'
}

void draw() {
  fill(98, 245, 31);
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height - height * 0.065);

  fill(98, 245, 31); // Green color
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) { 
  data = myPort.readStringUntil('.'); // Read serial data
  if (data != null) {
    data = trim(data);
    index1 = data.indexOf(","); 

    if (index1 > 0) { 
      angle = data.substring(0, index1);
      distance = data.substring(index1 + 1, data.length());

      iAngle = int(angle);
      iDistance = int(distance);
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.1); 
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  arc(0, 0, width * 0.85, width * 0.85, PI, TWO_PI);
  arc(0, 0, width * 0.6, width * 0.6, PI, TWO_PI);
  arc(0, 0, width * 0.35, width * 0.35, PI, TWO_PI);

  line(-width / 2, 0, width / 2, 0);
  for (int i = 30; i <= 150; i += 30) {
    line(0, 0, (-width / 2) * cos(radians(i)), (-width / 2) * sin(radians(i)));
  }
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(9);
  stroke(255, 10, 10); // Red color

  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025);

  if (iDistance < 40) {
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),
         (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(7);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.1);
  line(0, 0, (height - height * 0.15) * cos(radians(iAngle)), -(height - height * 0.15) * sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  pushMatrix();
  if (iDistance > 40) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }

  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);

  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);
  
  textSize(40);
  text("Barcode Radar System", width - width * 0.972, height - height * 0.0277);
  text("Angle: " + iAngle + "°", width - width * 0.54, height - height * 0.0277);
  text("Distance: ", width - width * 0.32, height - height * 0.0277);
  
  if (iDistance < 40) {
    text(iDistance + " cm", width - width * 0.160, height - height * 0.0277);
  }

  textSize(25);
  fill(98, 245, 60);
  
  int[] angles = {30, 60, 90, 120, 150};
  float[] xOffsets = {0.4994, 0.503, 0.507, 0.513, 0.5104};
  float[] yOffsets = {0.0907, 0.0888, 0.0833, 0.07129, 0.0574};
  float[] rotations = {-60, -30, 0, -30, -60};

  for (int i = 0; i < angles.length; i++) {
    resetMatrix();
    translate((width - width * xOffsets[i]) + width / 2 * cos(radians(angles[i])),
              (height - height * yOffsets[i]) - width / 2 * sin(radians(angles[i])));
    rotate(radians(rotations[i]));
    text(angles[i] + "°", 0, 0);
  }
  
  popMatrix();
}
