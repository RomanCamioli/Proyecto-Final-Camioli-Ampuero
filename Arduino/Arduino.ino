const int interruptorPin = 3;

int jugadorX;
long numRandom;

boolean partidaDemo = false;

void setup() {
  Serial.begin(9600);
  pinMode(interruptorPin, INPUT);
}

void loop() {
  int estadoInterruptor = digitalRead(interruptorPin);
  
  if(Serial.read() == 'W'){
    partidaDemo = true ;
  }//if
  
  if(partidaDemo){
    numRandom = random(101);
    Serial.write(numRandom);
    //Serial.println(numRandom);
  }//if
  
  else if(!partidaDemo){
    if(estadoInterruptor == HIGH){ //IZQUIERDA
    Serial.write(10);
    }//if
  
    else if(estadoInterruptor == LOW){ //DERECHA
    Serial.write(0);
      }
    }//else
  Serial.println(estadoInterruptor);
}//loop
