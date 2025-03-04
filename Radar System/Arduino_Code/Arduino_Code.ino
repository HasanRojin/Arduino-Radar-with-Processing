#include <Servo.h>

const int trigPin = 9;
const int echoPin = 10;
long duration;
int distance;
Servo myServo; // Object for servo motor

void setup() {
  pinMode(trigPin, OUTPUT);  // Set trigPin as an Output
  pinMode(echoPin, INPUT);   // Set echoPin as an Input
  Serial.begin(9600);
  myServo.attach(6); // Pin connected to servo
}

void loop() {
  // Rotating servo from 15 to 165 degrees
  for (int i = 15; i <= 165; i++) {
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }

  // Rotating servo back from 165 to 15 degrees
  for (int i = 165; i >= 15; i--) { // Fixed decrement operator (i--)
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

// Function to measure distance using ultrasonic sensor
int calculateDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2; // Convert time to distance
  
  return distance;
}
