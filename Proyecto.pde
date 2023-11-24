import processing.core.PImage;
import processing.serial.*;

String ListaPuertos[];
Serial MiPuerto;


  

float distanciaX, distanciaY,distanciaX1, distanciaY1, distanciaXvirus,distanciaYvirus;

boolean gameOver, gameStart;
boolean temporizadorActivo = true;
boolean juegoPausado = false;
boolean entradaNombre = true;

int nivel=0;
int aciertos = 0;
int tiempoLimite = 31000; // 30 segundos en milisegundos
int tiempoInicio;

PImage fondo, inicio, score;

String nombre = "";
ArrayList<String> listaJugadores = new ArrayList<String>(); //lista donde se almacenan todos los jugaadores

PrintWriter writer;

   public class Objeto { //                                                                              CREACION CLASE
        float x, y;
        PImage imagen;
        int diametro;
        int velocidad;
        int puntos;
         Objeto(){
          }//constructor
          
   void setObjeto(int diametro,float x, float y, int velocidad, int puntos) { //funcion para establecer los parametros de los obj
        this.diametro = diametro;
        this.x = x;
        this.y = y;
        this.velocidad = velocidad;
        ellipse(x, y, diametro, diametro);
        this.puntos = puntos;
          }
          
   void drawObjeto(String nombreImagen){ //funcion para subir y cargar imagenes
     imageMode(CENTER);
     imagen = loadImage(nombreImagen);
     image(imagen,x,y,diametro,diametro);
      }
    
  };//fin de clase
      
Objeto Jugador, Hueso, Carne, Virus;
   

void cargarDatos() { 
 // Intenta cargar los datos desde el archivo datos.txt al inicio del programa
 String[] lines = loadStrings("datos.txt");
  if (lines != null && lines.length > 0) {
    for (String line : lines) {
      listaJugadores.add(line);
    }
  }
}
   
void setup(){ //SETUP

ListaPuertos=Serial.list();//asignamos los puertos
println(ListaPuertos[0]);//mostramos el primer puerto disponible
MiPuerto=new Serial(this, ListaPuertos[0],9600);//asignamos el objeto serial al puerto seleccionado anteriormente

size(1280,720);
 
 cargarDatos(); 
imageMode(CENTER);
inicio = loadImage("imagenes/inicio.png"); //CARGO IMAGENES
fondo = loadImage("imagenes/fondo.png");
score = loadImage("imagenes/score.png");
gameOver = false;
gameStart = false;

                               //DECLARO ESPACIO DE MEMORIA PARA LOS OBJETOS
Jugador = new Objeto(); //                                                                                     MEMORIA
Hueso = new Objeto();
Carne = new Objeto();
Virus = new Objeto();

Jugador.setObjeto(80, width/2, height-60, 20,0);
Hueso.setObjeto(60, random(width), 0, 5,1); //                     HUESO
Carne.setObjeto(60, random(width), 0, 7,2); //                     CARNE
Virus.setObjeto(80, random(width), 0, 9,-3); //                    VIRUS
 tiempoInicio = millis();
};

void draw(){ //                                                                                                  DRAW
 // Jugador.x = MiPuerto.read();
  // 
    
  
  distanciaY = Jugador.y - Hueso.y;  //distancia del jugador al objeto
  distanciaX = Jugador.x - Hueso.x;
  
  distanciaY1 = Jugador.y - Carne.y;
  distanciaX1 = Jugador.x - Carne.x;
  
  distanciaYvirus = Jugador.y - Virus.y;
  distanciaXvirus = Jugador.x - Virus.x;
  
  if(!gameStart){
   background(#FF5789);
   image(inicio,width/2,height/2,width,height);
   
    //DATOS DEL JUGADOR                                                                                        PANTALLA INICIO
     if (entradaNombre) {
    textSize(40);
    fill(#FF5789);
    text("Ingresa tu nombre: " + nombre, 500, 250); //ingreso nombre
  } else {
    textSize(32);
    text("Hola, " + nombre + "!", 50, 250);
  }
   textSize(40);
   fill(#FF5789);
   textAlign(CENTER);
   text("PRESIONA ENTER PARA JUGAR",width/2, 330); //anuncio al keypress (enter)
   
   textSize(40);
   fill(#FF5789);
   textAlign(CENTER);
   text("DIFICULTAD: ",width/2, 450);  // muestro selector  de dificultad
   
   textSize(40);
   fill(#FF5789);
   textAlign(CENTER);
   text(nivel,width/2 + 130, 500);
   
   if(nivel < 4){
   fill(#FF5789);
   rect(width/2 + 130, 400 , 50*nivel, 50);
   }
   else if(nivel >= 4){
   fill(#FF5789);
    }
  }
  else if(gameStart){ //                                                                                          COMIENZO JUEGO
   background(#AFCBF7);
   image(fondo,width/2,height/2,width,height);               
   Jugador.drawObjeto("imagenes/perro.png");//CARGO IMAGENES PARA CADA OBJETO
   Hueso.drawObjeto("imagenes/hueso.png");
   Carne.drawObjeto("imagenes/carne.png");
   Virus.drawObjeto("imagenes/virus.png");
   
   textSize(40);
   fill(255);
   text(aciertos,width/16+40, height/15+50);
   Hueso.y += Hueso.velocidad;
   Carne.y += Carne.velocidad;
   Virus.y += Virus.velocidad;
   
   if (MiPuerto.available() > 0) { //siempre que el puerto este disponible..
    
    if( MiPuerto.read() == 10 ){//si el puerto recibe una señal HIGH mueve a la derecha...
     Jugador.x += Jugador.velocidad; 
     MiPuerto.clear();
    }
    
    else if( MiPuerto.read() != 10){//si recibe una señal distinta de 10 (low) mueve a la izq
     Jugador.x -= Jugador.velocidad; 
     MiPuerto.clear();
    }
    }
    //MiPuerto.clear();
 
  if (temporizadorActivo && !juegoPausado) {
    int tiempoTranscurrido = millis() - tiempoInicio;
    int tiempoRestante = tiempoLimite - tiempoTranscurrido;
    
    if (tiempoRestante <= 0) { //cuando se termina el tiempo, termina el juego
      temporizadorActivo = false;
      tiempoRestante = 0;
      juegoPausado = true; 
    }
    textSize(32);
    text("Time: " + tiempoRestante/1000 + " seg",150, 60);
  }
  

  if (juegoPausado) { //                                                                                           FIN DEL JUEGO
    if(juegoPausado == true){ //igualo a 0 para que se termine el juego
    Hueso.velocidad = 0;
    Carne.velocidad = 0;
    Virus.velocidad = 0; 
  }
   mostrarDatosJugadores(); //llamo funcion mostrar datos para que se ejecute una vez finalizado el juego
  }}
   //contador de aciertos cuando agarra x objeto
  if(distanciaY < Jugador.diametro && abs(distanciaX) < Jugador.diametro) {
   aciertos += Hueso.puntos; //HUESO
   Hueso.x = random(width);
   Hueso.y = 0;
  }
  if(distanciaY1 < Jugador.diametro && abs(distanciaX1) < Jugador.diametro) {
   aciertos += Carne.puntos; //CARNE
   Carne.x = random(width);
   Carne.y = 0;
  }
   if(distanciaYvirus < Jugador.diametro && abs(distanciaXvirus) < Jugador.diametro) {
   aciertos += Virus.puntos; //VIRUS
   Virus.x = random(width);
   Virus.y = 0;
  }
  //declaro que la posicion en x caiga aleatoriamente del hueso, virus y carne
  else if(Hueso.y >= height){
   Hueso.x = random(width);
   Hueso.y = 0;
   }
   else if(Carne.y >= height){
   Carne.x = random(width);
   Carne.y = 0;
  }
   else if(Virus.y >= height){
   Virus.x = random(width);
   Virus.y = 0;
  }
  //declaro al objeto de perro para que se mueva por teclado
  Jugador.x = constrain(Jugador.x, 0, width);
}//FIN DRAW

/////////////////////////////////////////////////////////////////////////////////////////FUNCIONES/////////////////////////////////////////////////////////////////////////////////////////////////////////////
void mostrarDatosJugadores() { //                                                                                   MOSTRAR DATOS JUGADORES
  background(#FF5789);
 image(score,width/2,height/2,width,height);
  textSize(60);
  textAlign(CENTER);
  fill(#FF5789);
  text("Jugador:", 500, 250);
  fill(#FF5789);
  textAlign(CENTER);
  fill(#FF5789);
  textAlign(CENTER);
  text(nombre, 800, 250);
  text("Tu puntuación es:", 500, 350);
  fill(#FF5789);
  textAlign(CENTER);
  text(aciertos, 800, 350);
  
    // Muestra al jugador anterior
  if (listaJugadores.size() > 0) {
    fill(#FFFFFF);
    textAlign(CENTER);
    textSize(25);
    text("Jugador Anterior: \n" + listaJugadores.get(listaJugadores.size() - 1), 900, 550);
  }

  // Encuentra el puntaje más alto
  int puntajeMasAlto = 0;
  String jugadorMasAlto = "";
  for (String jugador : listaJugadores) {
    String[] partes = split(jugador, ",");
    int puntaje = int(split(partes[1], ":")[1].trim());
    if (puntaje > puntajeMasAlto) {
      puntajeMasAlto = puntaje;
      jugadorMasAlto = jugador;
    }
  }

  // Muestra el puntaje más alto
  if (!jugadorMasAlto.equals("")) {
    fill(#FFFFFF);
    textAlign(CENTER);
    textSize(25);
    text("Puntaje Más Alto: \n" + jugadorMasAlto, 400, 550);
  }
}
void guardarDatos() {
  listaJugadores.add("Nombre: " + nombre + ", Puntuación: " + aciertos);

  // Intenta escribir toda la lista al archivo "datos.txt"
  try {
    writer = createWriter("datos.txt");
    for (String jugador : listaJugadores) {
      writer.println(jugador);
    }
    writer.flush();
    writer.close();
  } catch (Exception e) {
    println("Error al guardar los datos: " + e.getMessage());
  }
}
void keyPressed(){ //                                                                                                     KEYPRESS

  if(keyCode == ENTER && gameStart == false){ //al apretar enter inicia el juego y el temporizador
    gameStart = true;
    tiempoInicio = millis();
    temporizadorActivo = true;
    juegoPausado = false;
  }

  if(keyCode == UP && Hueso.velocidad < 20 && nivel < 4){ //sube la dificultad del juego
    Hueso.velocidad += 5;
    Carne.velocidad += 7;
    Virus.velocidad += 9;
    nivel++;
    
  }
  if(keyCode == DOWN && Hueso.velocidad > 0 && nivel > 0){ //baja la dificultad del juego
    Hueso.velocidad -= 5;
    Carne.velocidad -= 7;
    Virus.velocidad -= 9; 
    nivel--;
  }
   if (entradaNombre) {                                 //para ingresar el nombre del jugador
    if (key == '\n') {  
      entradaNombre = false;
    
    } 
    else if (key == BACKSPACE) {  
      
        if (nombre.length() > 0) {
            nombre = nombre.substring(0, nombre.length() - 1);
        }
    } 
    else {
      nombre = nombre + key;
    }
  }
    if (keyCode == ESC) {    // para salir del juego y guardar los datos del jugador en el archivo
    guardarDatos();
    exit(); 
  }
  
  if(keyCode == 'W' && gameStart == false){
    gameStart = true;
    tiempoInicio = millis();
    temporizadorActivo = true;
    juegoPausado = false;
    MiPuerto.write("W");
   partidaDemo(); 
  }
  
}

void partidaDemo(){
  if (MiPuerto.available() > 0) { //siempre que el puerto este disponible..
    
    if( MiPuerto.read() < 50 ){//si el puerto recibe una señal HIGH mueve a la derecha...
     Jugador.x += Jugador.velocidad; 
     //MiPuerto.clear();
    }
    
    else if( MiPuerto.read() > 50){//si recibe una señal distinta de 10 (low) mueve a la izq
     Jugador.x -= Jugador.velocidad; 
     //MiPuerto.clear();
    }
    }
}
  
