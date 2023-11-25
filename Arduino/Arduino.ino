int interruptorPin = 3;

unsigned int estadoInterruptor;
unsigned const int izquierda = 0, derecha = 1;
int movimiento;

bool partidaDemo = false, replay = false;

void setup() {
  Serial.begin(9600);
  pinMode(interruptorPin, INPUT);
}

void loop() {
  
  estadoInterruptor = digitalRead(interruptorPin);
  char dato = Serial.read();

  if( dato == 'W' ){
    partidaDemo = true ;
    //Serial.println("Partida demo activa");
  }//if

  if(partidaDemo == true){

    movimiento = random(2);
    //Serial.println("Partida demo activa");

      if(movimiento == 1){
        Serial.write(derecha);
      }//if

      else{
        Serial.write(izquierda);
      }//else

  }//if partidaDemo

  else if(partidaDemo == false && replay == false){
 
    if(estadoInterruptor == HIGH){ //derecha
    Serial.write(derecha);
    }//if
  
    else if(estadoInterruptor == LOW){ //izq
    Serial.write(izquierda);
      }
    }//else (para jugar la partida)

    if( dato == 'L' ){
    replay = true ;
    //Serial.println("Partida demo activa");
  }//if

  if(replay == true){

    
    //Serial.println("Partida replay activa");

      if(dato == '1'){
        Serial.write(derecha);
        //Serial.println("derecha");
      }//if

      else if(dato == '0'){
        Serial.write(izquierda);
        //Serial.println("izquierda");
      }//else

  }//if replay


}//loop