int interruptorPin = 4;

unsigned const int izquierda = 0, derecha = 1;
int movimiento;

bool partidaDemo = false, replay = false, partida = true;

void setup() {
  Serial.begin(9600);
  pinMode(interruptorPin, INPUT);
}

void loop() {
  
  unsigned int estadoInterruptor = digitalRead(interruptorPin);

  if(Serial.read() == 'W'){
    partidaDemo = true ;
    partida = false;
  }//if

  if(partidaDemo){

    movimiento = random(2);
      if(movimiento == 0){
        Serial.write(derecha);
      }//if

      else{
        Serial.write(izquierda);
      }//else
  }//if
  
  else if(partida){
    partidaDemo = false;
    replay = false;

    if(estadoInterruptor == HIGH){ //derecha
    Serial.write(derecha);
    }//if
  
    else if(estadoInterruptor == LOW){ //izq
    Serial.write(izquierda);
      }
    }//else

  if(Serial.read() == 'L'){
    replay = true;
    partidaDemo = false;
    partida = false;
  }
  if(replay){
    
    movimiento = Serial.read();
      if(movimiento == 0){
        Serial.write(derecha);
      }//if

      else{
        Serial.write(izquierda);
      }//else
  }
}//loop
