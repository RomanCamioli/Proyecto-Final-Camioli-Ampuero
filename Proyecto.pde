
float distanciaX, distanciaY,distanciaX1, distanciaY1, distanciaXvirus,distanciaYvirus;
boolean gameOver, gameStart;
int aciertos = 0;
import processing.core.PImage;
int nivel;
PImage fondo;
PImage score;
PImage inicio;
int tiempoLimite = 11000; // 30 segundos en milisegundos
int tiempoInicio;
boolean temporizadorActivo = true;
boolean juegoPausado = false;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.ArrayList;

ArrayList<String> datosJugadores = new ArrayList<String>();
String nombreJugador = "";
int puntuacion = 0;
boolean entradaNombre = true;
PrintWriter writer;

public class Objeto {
    float x, y;
    PImage imagen;
    int diametro;
    int velocidad;
    int puntos;
     Objeto(){
    }//atributos
 
   void setObjeto(int diametro,float x, float y, int velocidad, int puntos) {
        
        this.diametro = diametro;
        this.x = x;
        this.y = y;
        this.velocidad = velocidad;
        ellipse(x, y, diametro, diametro);
        this.puntos = puntos;
    }// set
    
    void drawObjeto(String nombreImagen){
     imageMode(CENTER);
     imagen = loadImage(nombreImagen);
     image(imagen,x,y,diametro,diametro);
    }//draw
    
};//clase

Objeto Jugador, Hueso, Carne, Virus;




void setup(){ //                   SETUP
 size(1280,720);
 writer = createWriter("datos.txt");
 cargarDatosDesdeArchivo();
 
imageMode(CENTER);
inicio = loadImage("imagenes/inicio.png");
fondo = loadImage("imagenes/fondo.png");
score = loadImage("imagenes/score.png");
gameOver = false;
gameStart = false;
aciertos = 0;


Jugador = new Objeto(); 
Hueso = new Objeto();
Carne = new Objeto();
Virus = new Objeto();// guardo memoria para los objetos

Jugador.setObjeto(80, width/2, height-60, 20,0);

Hueso.setObjeto(60, random(width), 0, 5,1); 
Carne.setObjeto(60, random(width), 0, 7,2); 
Virus.setObjeto(80, random(width), 0, 9,-3); // se setean los atributos iniciales de los objetivos
nivel = 0;
tiempoInicio = millis();
 
};//                   SETUP

void draw(){ //              DRAW

  distanciaY = Jugador.y - Hueso.y;
  distanciaX = Jugador.x - Hueso.x;
  
  distanciaY1 = Jugador.y - Carne.y;
  distanciaX1 = Jugador.x - Carne.x;
  
  distanciaYvirus = Jugador.y - Virus.y;
  distanciaXvirus = Jugador.x - Virus.x;// calculo de las distancias entre jugador y objetivo para su colision
  
  if(!gameStart){
   background(#FF5789);
   image(inicio,width/2,height/2,width,height);
   
    //                                DATOS DEL JUGADOR
     if (entradaNombre) {
    textSize(40);
    fill(#FF5789);
     //textAlign(CENTER);
     
    text("Ingresa tu nombre: " + nombreJugador, 500, 250);//ingreso del nombre de jugador
  } else {
    textSize(32);
    text("Hola, " + nombreJugador + "!", 50, 250);
  }
   textSize(40);
   fill(#FF5789);
   textAlign(CENTER);
   text("PRESIONA ENTER PARA JUGAR",width/2, 330);
   
   textSize(40);
   fill(#FF5789);
   textAlign(CENTER);
   text("DIFICULTAD: ",width/2, 450);
   
   textSize(40);
   fill(#FF5789);
   textAlign(CENTER);
   text(nivel,width/2 + 130, 500);
   
   
   if(nivel < 4){
   fill(#FF5789);
   rect(width/2 + 130, 400 , 50*nivel, 50);
   }// rectangulos que muestran graficamente el nivel seleccionado
   else if(nivel >= 4){
   fill(#FF5789);
    }
    
  }
  
  else if(gameStart){//cuando empieza el juego
 
   background(#AFCBF7);
   image(fondo,width/2,height/2,width,height);
   Jugador.drawObjeto("imagenes/perro.png");
   Hueso.drawObjeto("imagenes/hueso.png");
   Carne.drawObjeto("imagenes/carne.png");
   Virus.drawObjeto("imagenes/virus.png");//se dibujan las imagenes
   
   textSize(40);
   fill(255);
   text(aciertos,width/16+40, height/15+50);//se escriben en pantalla los aciertos
   
   Hueso.y += Hueso.velocidad;
   Carne.y += Carne.velocidad;
   Virus.y += Virus.velocidad;//moviemto de caida de los objetos a partir de sus atributos de veloci. y coordenada "y"
 
  if (temporizadorActivo && !juegoPausado) {
    int tiempoTranscurrido = millis() - tiempoInicio;
    int tiempoRestante = tiempoLimite - tiempoTranscurrido;
    
    if (tiempoRestante <= 0) {
      temporizadorActivo = false;
      tiempoRestante = 0;
      juegoPausado = true;
     
    }// cuando termina el tiempo
    
    
    textSize(32);
    text("Time: " + tiempoRestante/1000 + " seg",150, 60);
    
  }// funcion para el temporizador
  
  if (juegoPausado) {
  
    if(juegoPausado == true){
    Hueso.velocidad = 0;
    Carne.velocidad = 0;
    Virus.velocidad = 0; 
    
  }//if
 
    writer.println("Jugador: "+nombreJugador + "\nPuntuación: " + aciertos);
    writer.flush();
    mostrarDatosJugadores();
    guardarDatosEnArchivo();
    
  }//juego "pausado"
   
   
   
  }// juego inicializado

  
  if(distanciaY < Jugador.diametro && abs(distanciaX) < Jugador.diametro) {
   aciertos += Hueso.puntos; //                                                       HUESO
   Hueso.x = random(width);
   Hueso.y = 0;
  }
  if(distanciaY1 < Jugador.diametro && abs(distanciaX1) < Jugador.diametro) {
   aciertos += Carne.puntos; //                                                       CARNE
   Carne.x = random(width);
   Carne.y = 0;
  }
  
   if(distanciaYvirus < Jugador.diametro && abs(distanciaXvirus) < Jugador.diametro) {
   aciertos += Virus.puntos; //                                                       VIRUS
   Virus.x = random(width);
   Virus.y = 0;
  }
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
  }//                                                estos if hacen que se reinicien los objetivos luego de la colision o caida, en caso de colision suma o resta puntos
  Jugador.x = constrain(Jugador.x, 0, width);
  
}//               DRAW

  void mostrarDatosJugadores() {
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
  text(nombreJugador, 800, 250);
  text("Tu puntuación es:", 500, 350);
  fill(#FF5789);
  textAlign(CENTER);
  text(aciertos, 800, 350);

    ///////////////JUGADOR ANTERIOIR////////////
  textSize(40);
  fill(255);
  textAlign(CENTER);
  fill(0);
  text("Jugador Anterior:", 400, 500);
 if (datosJugadores.size() > 0) {
    String ultimoDato = datosJugadores.get(datosJugadores.size() - 1);
    String[] partes = split(ultimoDato, ' ');
    String jugadorAnterior = partes[1];
    String puntuacionAnterior = partes[3];

    textSize(32);
    fill(255);
    textAlign(CENTER);
    fill(0);
    text("Jugador: " + jugadorAnterior, 400, 550);
    fill(0);
    text("Puntuación: " + puntuacionAnterior, 400, 600);
  }
  
  ////////////PUNTUACION MAS ALTA//////////////////////////////////////////////
  
   // Buscar al jugador con la puntuación más alta
  if (datosJugadores.size() > 1) {
    int puntuacionMasAlta = 0;
    String jugadorMasAlto = "";

    for (String dato : datosJugadores) {
      String[] partes = split(dato, ' ');
      int puntuacion = int(partes[3]);

      if (puntuacion > puntuacionMasAlta) {
        puntuacionMasAlta = puntuacion;
        jugadorMasAlto = partes[1];
      }
    }
  textSize(40);
  fill(255);
  textAlign(CENTER);
  fill(0);
  text("Puntucion Mas Alta:",900, 500);
    textSize(32);
    fill(255);
    textAlign(CENTER);
    fill(0);
    text("Jugador: " + jugadorMasAlto, 900, 550);
    text("Puntuación: " + puntuacionMasAlta, 900, 600);
  }
}//    funcion mostrar datos de jugadores


void cargarDatosDesdeArchivo() {
  try {
    BufferedReader reader = new BufferedReader(new FileReader("datos.txt"));
    String linea;
    while ((linea = reader.readLine()) != null) {
      datosJugadores.add(linea);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}// funcion cargar datos desde archivo

void guardarDatosEnArchivo() {
  try {
    FileWriter fileWriter = new FileWriter("datos.txt", true); // El segundo parámetro true permite la escritura al final del archivo
    PrintWriter printWriter = new PrintWriter(fileWriter);
    printWriter.println("Jugador: " + nombreJugador + " Puntuación: " + aciertos);
    printWriter.close();
  } catch (IOException e) {
    e.printStackTrace();
  }//try catch
  
}//funcion guardar datos en archivo

void keyPressed(){

   
  if(keyCode == ENTER && gameStart == false){
    gameStart = true;
    tiempoInicio = millis();
    temporizadorActivo = true;
    juegoPausado = false;
  }                      //empieza el juego
  if(keyCode == LEFT){
  Jugador.x -= Jugador.velocidad;
  }  
  else if(keyCode == RIGHT){
  Jugador.x += Jugador.velocidad;
  }                      //movimiento
  if(keyCode == UP && Hueso.velocidad < 20 && nivel < 4){
    Hueso.velocidad += 5;
    Carne.velocidad += 7;
    Virus.velocidad += 9;
    nivel++;
    
  }                      //cambia las velocidades segun el nivel
  if(keyCode == DOWN && Hueso.velocidad > 0 && nivel > 0){
    Hueso.velocidad -= 5;
    Carne.velocidad -= 7;
    Virus.velocidad -= 9; 
    nivel--;
  }                      //cambia las velocidades segun el nivel
  
   if (entradaNombre) {
    if (key == '\n') {  // cuando se presiona enter finaliza la entrada de nombre
      entradaNombre = false;
    
    } else if (key == BACKSPACE) {  // si se presiona la tecla de borrar, borra un carácter
      if (nombreJugador.length() > 0) {
        nombreJugador = nombreJugador.substring(0, nombreJugador.length() - 1);
      }
    } else {
      nombreJugador = nombreJugador + key;
    }
  }
  
  }//key pressed
