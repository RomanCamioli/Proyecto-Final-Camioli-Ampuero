int interruptorPin = 3;

int magenta = 10, amarillo = 9 , cian = 11;

unsigned int estadoInterruptor;
unsigned const int izquierda = 0, derecha = 1;
int movimiento;

bool partidaDemo = false, replay = false, pantallaInicio = true;

void setup() {
  Serial.begin(9600);
  pinMode(interruptorPin, INPUT);

  pinMode(magenta, OUTPUT);
  pinMode(cian, OUTPUT);
  pinMode(amarillo, OUTPUT);
}

void loop() {
  
  estadoInterruptor = digitalRead(interruptorPin);
  char dato = Serial.read();

  if(pantallaInicio == true){

    digitalWrite(magenta, HIGH);
  delay(200);
  digitalWrite(magenta, LOW);
  delay(10);
  
  digitalWrite(cian, HIGH);
  delay(200);
  digitalWrite(cian, LOW);
  delay(10);
  
  digitalWrite(amarillo, HIGH);
  delay(200);
  digitalWrite(amarillo, LOW);
  delay(10);
  }

  if(dato == 'M'){
    pantallaInicio = false;
  }

  if( dato == 'W' ){
    partidaDemo = true ;

  }//if

  if(partidaDemo == true){

    pantallaInicio = false;
    
    digitalWrite(cian, HIGH);
    digitalWrite(magenta, LOW);
    digitalWrite(amarillo, LOW);
    
    movimiento = random(2);

      if(movimiento == 1){
        Serial.write(derecha);
      }//if

      else{
        Serial.write(izquierda);
      }//else

  }//if partidaDemo

  else if(partidaDemo == false && replay == false && pantallaInicio == false){

    
    digitalWrite(magenta, HIGH);
    digitalWrite(amarillo, LOW);
    digitalWrite(cian, LOW);
    
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
    
    pantallaInicio = false;
    partidaDemo = false;
    
    digitalWrite(cian, LOW);
    digitalWrite(magenta, LOW);
    digitalWrite(amarillo, HIGH);

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
