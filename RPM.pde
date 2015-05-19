

import processing.serial.*;
 
Serial port;
 
PrintWriter output;  
int rquad=40; 
int xquad=200;  
int yquad=200;  

boolean overRect = false; //Estado del mouse si está encima de rect o no
 
//Colores del botón
int red=100;
int green=100;
int blue=100;
 
boolean status=false; //Estado del color de rect
String texto="";//Texto del status inicial del LED
 
int xlogo=400;//Posición X de la imagen
int ylogo=50;//Posición Y de la imagen
 
int valor;//Valor de la velocidad
 

 
void setup()
{
  println(Serial.list()); //Visualiza los puertos serie disponibles en la consola de abajo
  port = new Serial(this, Serial.list()[11], 9600); //Abre el puerto serie COM11
   
  output = createWriter("velocidad_datos.txt"); //Creamos el archivo de texto, que es guardado en la carpeta del programa
   
  size(800, 400); //Creamos una ventana de 800 píxeles de anchura por 600 píxeles de altura 
}
 
void draw()
{
  background(255,255,255);//Fondo de color blanco
    
  if(mouseX > xquad-rquad && mouseX < xquad+rquad &&  //Si el mouse se encuentra dentro de rect
     mouseY > yquad-rquad && mouseY < yquad+rquad)
     {
       overRect=true;  //Variable que demuestra que el mouse esta dentro de rect
       stroke(255,0,0);  //Contorno de rect rojo
     }
   else
   {
     overRect=false;  //Si el mouse no está dentro de rect, la variable pasa a ser falsa
     stroke(0,0,0);  //Contorno de rect negro
   }
   
  //Dibujamos un rectangulo de color gris
  fill(red,green,blue);
  rectMode(RADIUS); //Esta función hace que Width y Height de rect sea el radio (distancia desde el centro hasta un costado).
  rect(xquad,yquad,rquad,rquad);
   
  
  fill(0,0,0);
  PFont f = loadFont("Aharoni-Bold-48.vlw");//Tipo de fuente
  textFont(f, 20);
  text(texto, 170, 270);
   
  //Ponemos la imagen de nuestro logo
  imageMode(CENTER);//Esta función hace que las coordenadas de la imagne sean el centro de esta y no la esquina izquierda arriba
  PImage imagen=loadImage("logo.jpg");
  image(imagen,xlogo,ylogo,200,100);
 
  //Recibir datos velocidad del Arduino 
  if(port.available() > 0) // si hay algún dato disponible en el puerto
   {
     valor=port.read();//Lee el dato y lo almacena en la variable "valor"
   }
   //Visualizamos la velocidad con un texto
   text("Velocidad =",590,200);
   text(valor, 720, 200);
   
    
   //Escribimos los datos de la velocidad con el tiempo (h/m/s) en el archivo de texto
   output.print(valor);
   output.print(hour( )+":");
   output.print(minute( )+":");
   output.println(second( ));
   output.println("");
    

}
 
void mousePressed()  //Cuando el mouse está apretado
{
  if (overRect==true) //Si el mouse está dentro de rect
  {
    status=!status; //El estado del color cambia
    port.write("A"); //Envia una "A" al Arduino 
   
    
  }
}
 
void keyPressed() //Cuando se pulsa una tecla
{
 
  //Pulsar la tecla E para salir del programa
  if(key=='e' || key=='E')
  {
    output.flush(); // Escribe los datos restantes en el archivo
    output.close(); // Final del archivo
    exit();//Salimos del programa
  }
}
