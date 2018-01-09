//Musikk legges i lister. Noe duplikat kode. Generisk beholder? 
//Leser output fra arduinokode slik at riktig tag (= spilleliste) spilles av. Sliter med hopping på tvers av lister, når button presses.

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.video.*;
import processing.sound.*;
import processing.serial.*;

PlayMusic pmusic = new PlayMusic();
PlayMovie pmovie = new PlayMovie();

Serial myPort; // Create object from Serial class
String value; // Data received from the serial port
int count=0;
int count2=0;

Minim minim;
Minim minim2;

AudioPlayer[] player = new AudioPlayer[3];
AudioPlayer[] player2 = new AudioPlayer[3];
  

 void setup(){
  
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  
  size(600, 260);
  
  //audioplayer 1, liste 1. Filmene musikkenfilene MÅ ligge i MyPlayer/data mappen. Finner under ('Sketch' - 'show sketch folder')
  minim = new Minim(this); 
  player[0] = minim.loadFile("02Diamonds.mp3"); 
  player[1] = minim.loadFile("01OldPine.mp3");
  player[2] = minim.loadFile("groove.mp3");

  //audioplayer 2, liste 2
  minim2 = new Minim(this);
  player2[0] = minim2.loadFile("Fink - Berlin Sunrise.mp3");
  player2[1] = minim2.loadFile("Fink - Fear Is Like Fire.mp3");
  player2[2] = minim2.loadFile("Fink - Foot in the Door.mp3");
 }

 void serialEvent(Serial myPort){
  
 if (myPort.available() > 0) {  // If data is available,
   value = myPort.readStringUntil('\n');   // read it and store it in val
      
     if(value != null) {
       value = trim(value);
       println(value);
       
       if (value.equals(pmusic.musikkListe1)) {
         pmusic.spillAvListe1();
       }
       if (value.equals(pmusic.musikkListe2)) {
         pmusic.spillAvListe2();
       }
       if(value.equals("fremover")){
       pmusic.nextSong();
       }
       if(value.equals("bakover")){
         pmusic.previousSong();
       }
     }
   }
 }

void draw(){
}


class PlayMusic {

  String musikkListe1 = "D0 C6 1B A4";
  String musikkListe2 = "04 32 86 39 74 23 80";
  
  void spillAvListe1 () {
    
   if (player2[count2].isPlaying()){
     player2[count2].close();
   }
   if(!player[count].isPlaying()) { 
     count++; 
     if(count>2)count=0; 
     player[count].play();
   }
 }
 
 void spillAvListe2 () {
   
   if(player[count].isPlaying()) {
     player[count].close();
   }
   if(!player2[count2].isPlaying()) { 
     count2++;
     if(count2>2)count2=0; 
     player2[count2].play();   
   } 
 }
 
 void nextSong(){
   
   if(player[count].isPlaying()){
     player[count].close();
     count ++;
     if(count>2) count = 0;{
     player[count].loop();
     }
   }
   if(player2[count2].isPlaying()){
     player2[count2].close();
     count2++;
     if(count2>2) count2=0;
     player2[count2].loop();
   }
 }
 
 void previousSong(){
   
   if(player[count].isPlaying()){
     player[count].close();
     count --;
     if(count<2) count = 0;
     player[count].loop();
   }
   if(player2[count2].isPlaying()){
     player2[count2].close();
     count2--;
     if(count2<2) count2=0;
     player2[count2].loop();
   }
 }

} //end class



class PlayMovie {
}
