
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
    }
 
   void setObjeto(int diametro,float x, float y, int velocidad, int puntos) {
        
        this.diametro = diametro;
        this.x = x;
        this.y = y;
        this.velocidad = velocidad;
        ellipse(x, y, diametro, diametro);
        this.puntos = puntos;
    }
    void drawObjeto(String nombreImagen){
     imageMode(CENTER);
     imagen = loadImage(nombreImagen);
     image(imagen,x,y,diametro,diametro);
    }
};

Objeto Jugador, Hueso, Carne, Virus;




void setup(){ /////////////////////////////////SETUP
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


Jugador = new Objeto(); //////////////////////////////guardo memoria
Hueso = new Objeto();
Carne = new Objeto();
Virus = new Objeto();

Jugador.setObjeto(80, width/2, height-60, 20,0);

Hueso.setObjeto(60, random(width), 0, 5,1); ///////////////////////////////////////HUESO
Carne.setObjeto(60, random(width), 0, 7,2); /////////////////////////////////////////CARNE
Virus.setObjeto(80, random(width), 0, 9,-3); //////////////////////////////////////// VIRUS
int nivel = 0;
 tiempoInicio = millis();
};

void draw(){ ///////////////////////////////////////////////////////////////////////////7DRAW

  distanciaY = Jugador.y - Hueso.y;
  distanciaX = Jugador.x - Hueso.x;
  
  distanciaY1 = Jugador.y - Carne.y;
  distanciaX1 = Jugador.x - Carne.x;
  
  distanciaYvirus = Jugador.y - Virus.y;
  distanciaXvirus = Jugador.x - Virus.x;
  
  if(!gameStart){
   background(#FF5789);
   image(inicio,width/2,height/2,width,height);
   
    ////////////////////////////////////////////////////////////////////DATOS DEL JUGADOR
     if (entradaNombre) {
    textSize(40);
    fill(#FF5789);
     //textAlign(CENTER);
    text("Ingresa tu nombre: " + nombreJugador, 500, 250);
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
   }
   else if(nivel >= 4){
   fill(#FF5789);
    }
    
  }
  
  else if(gameStart){
 
  /////////////////////////////////////////////////////777
   background(#AFCBF7);
   image(fondo,width/2,height/2,width,height);
   Jugador.drawObjeto("imagenes/perro.png");
   Hueso.drawObjeto("imagenes/hueso.png");
   Carne.drawObjeto("imagenes/carne.png");
   Virus.drawObjeto("imagenes/virus.png");
   
   textSize(40);
   fill(255);
   text(aciertos,width/16+40, height/15+50);
   Hueso.y += Hueso.velocidad;
   Carne.y += Carne.velocidad;
   Virus.y += Virus.velocidad;
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////7
 
  if (temporizadorActivo && !juegoPausado) {
    int tiempoTranscurrido = millis() - tiempoInicio;
    int tiempoRestante = tiempoLimite - tiempoTranscurrido;
    
    if (tiempoRestante <= 0) {
      temporizadorActivo = false;
      tiempoRestante = 0;
      juegoPausado = true;
     
    }
    
    
    textSize(32);
    text("Time: " + tiempoRestante/1000 + " seg",150, 60);
  }
  
  if (juegoPausado) {
    // finalizado.
    if(juegoPausado = true){
    Hueso.velocidad = 0;
    Carne.velocidad = 0;
    Virus.velocidad = 0; 
  }
 
    writer.println("Jugador: "+nombreJugador + "\nPuntuación: " + aciertos);
    writer.flush();
    mostrarDatosJugadores();
    guardarDatosEnArchivo();
  }
   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
   
   
  }

  
  if(distanciaY < Jugador.diametro && abs(distanciaX) < Jugador.diametro) {
   aciertos += Hueso.puntos; ////////////////////////////////////////////////////////HUESO
   Hueso.x = random(width);
   Hueso.y = 0;
  }
  if(distanciaY1 < Jugador.diametro && abs(distanciaX1) < Jugador.diametro) {
   aciertos += Carne.puntos; ////////////////////////////////////////////////////////CARNE
   Carne.x = random(width);
   Carne.y = 0;
  }
  
   if(distanciaYvirus < Jugador.diametro && abs(distanciaXvirus) < Jugador.diametro) {
   aciertos += Virus.puntos; ////////////////////////////////////////////////////////VIRUS
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
  }
  Jugador.x = constrain(Jugador.x, 0, width);
}/////////////////////////////////////////////////////////////////////////////////////////////////////////////7
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
}

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
}

void guardarDatosEnArchivo() {
  try {
    FileWriter fileWriter = new FileWriter("datos.txt", true); // El segundo parámetro true permite la escritura al final del archivo
    PrintWriter printWriter = new PrintWriter(fileWriter);
    printWriter.println("Jugador: " + nombreJugador + " Puntuación: " + aciertos);
    printWriter.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void keyPressed(){
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
  if(keyCode == ENTER && gameStart == false){
    gameStart = true;
    tiempoInicio = millis();
    temporizadorActivo = true;
    juegoPausado = false;
  }
  if(keyCode == LEFT){
  Jugador.x -= Jugador.velocidad;
  }
  else if(keyCode == RIGHT){
  Jugador.x += Jugador.velocidad;
  }
  if(keyCode == UP && Hueso.velocidad < 20 && nivel < 4){
    Hueso.velocidad += 5;
    Carne.velocidad += 7;
    Virus.velocidad += 9;
    nivel++;
    
  }
  if(keyCode == DOWN && Hueso.velocidad > 0 && nivel > 0){
    Hueso.velocidad -= 5;
    Carne.velocidad -= 7;
    Virus.velocidad -= 9; 
    nivel--;
  }
   if (entradaNombre) {
    if (key == '\n') {  // Cuando se presiona Enter, finaliza la entrada de nombre
      entradaNombre = false;
    
    } else if (key == BACKSPACE) {  // Si se presiona la tecla de retroceso, borra un carácter
      if (nombreJugador.length() > 0) {
        nombreJugador = nombreJugador.substring(0, nombreJugador.length() - 1);
      }
    } else {
      nombreJugador = nombreJugador + key;
    }
  }
  
}
