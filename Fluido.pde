/**
 * Loop. 
 * 
 * Shows how to load and play a QuickTime movie file.  
 *
 */

import processing.video.*;
import gab.opencv.*;

CannyEdgeDetector detector = new CannyEdgeDetector();
PImage changed;
PImage orig;
PImage subImg;
Movie movie;
OpenCV opencv;

int RefX, refInd, refAmp;
int[] RefY={0,0};
float Escala;
int BoxWidth = 150, BoxHeight = 100, BoxPosX = 200, BoxPosY = 175;
float meanY;
float countY;
boolean drawChanged = true;
boolean record = false;

PrintWriter outFile;

Capture video;

void setup() {
  size(640, 480);
  background(0);
  // Load and play the video in a loop
  //movie = new Movie(this, "C:/fluido.mov");
  //movie.loop();
  
  // Uses the default video input, see the reference if this causes an error
  String camaras[] = video.list();
  println(camaras);
  video = new Capture(this, camaras[0]);
  video.start();
  
  //opencv = new OpenCV(this, 640, 480);
  //opencv.startBackgroundSubtraction(15, 3, 0.2);
  
  detector.setLowThreshold(0.5f);
  detector.setHighThreshold(4.0f);
  
  ellipseMode( RADIUS );
  outFile = createWriter("wave.txt");
}

/*void movieEvent(Movie m) {
  m.read();
}*/

void draw() {
  if (video.available()){
  video.read();
  
  orig = video;
  subImg = orig.get(BoxPosX, BoxPosY, BoxWidth, BoxHeight);
  detector.setSourceImage((java.awt.image.BufferedImage)subImg.getNative());
  detector.process();
  BufferedImage edges = detector.getEdgesImage();
  changed = new PImage(edges);
  
  image(video, 0, 0, width, height);
  //image(changed, BoxPosX/2, BoxPosY/2, BoxWidth, BoxHeight);
  if( drawChanged )
    image(changed, BoxPosX, BoxPosY, BoxWidth, BoxHeight);

  fill( 250, 10, 10, 100);
  ellipse( RefX, RefY[0], 5, 5 );
  ellipse( RefX, RefY[1], 5, 5 );

  if( record ){
    meanY=0; countY=0;
    int oldY = 0;
    //print( millis()+" ");
    outFile.print(millis()+" ");
    //Busquemos la posición del borde.
    for( int x=15; x<BoxWidth-10; x++){
      for( int y=10; y<BoxHeight-10; y++){
        //if( changed.get( x, y ) > 0 ){
          int colorPixel = changed.get(x,y);
          if( colorPixel > -1e6 ){
             meanY = BoxHeight - y;
             //print( x+" "+y+" ");
             outFile.print( x+" "+meanY*Escala+" ");
             oldY = y;
        }
        /*else{ //Esto escribe datos que no son reales. Repite la posición del último pixel válido.
          print( x+" "+y+" ");
          outFile.print( x+" "+oldY+" ");
        }*/
      }
    }
    //println();
    outFile.println();
    //record = false;
  }
  //meanY = meanY / countY;
  //println( meanY );
  //ellipse( BoxPosX/2, BoxPosY/2 + meanY/2, 5, 5);
  
  }
}

void mousePressed() {
 RefX = mouseX;
 if( refInd==1 )
   refInd = 0;
 else
   refInd = 1;
 RefY[refInd] = mouseY;
 refAmp = abs( RefY[0] - RefY[1]);
 Escala = 10.0/refAmp;
}

void keyPressed(){
 if( key == 'd' )
   drawChanged = !drawChanged;
 else if( key == 'r' )
   record = !record;
}

void exit(){
 println("Chau picho");
 outFile.flush();
 outFile.close();
 super.exit();
}