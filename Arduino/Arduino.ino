const int interruptorPin = 3;

void setup() {
  Serial.begin(9600);
  pinMode(interruptorPin, INPUT);
}

void loop() {
  int estadoInterruptor = digitalRead(interruptorPin);

  if(estadoInterruptor == HIGH){
  Serial.write(10);
  }
  else if(estadoInterruptor == LOW){
  Serial.write(0);
  }

  Serial.println(estadoInterruptor);
}
