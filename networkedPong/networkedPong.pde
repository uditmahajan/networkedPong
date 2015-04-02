import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int base=10;
float x,y, gameScore=0;
int changeX=-2;
int changeY=-2;
int gameOver=0;
float posX=0;
float posY = 0;

void setup()
{
  oscP5 = new OscP5(this,12345);
  myRemoteLocation = new NetAddress("x.x.x.x",12345);
  
  size(500, 500);
  x=width/2;
  y=height-base;
  posY=height-base;
}
void draw()
{
  if(gameOver==0)
  {
  background(0); 
  rect(mouseX,posY,100,base);
  rect(posX,0,100,base);
  ellipse(x,y,20,20);
  x=x+changeX;
  y=y+changeY;
  if(x<0 | x>width)
  {
    changeX=-changeX;
  }
  if(y<base*2)
  {
    if(x>posX && x<posX+100)
    {
      changeY=-changeY;
    }
  }
  if(y>height-(base*2))
  {
    
    if(x>mouseX && x<mouseX+100)
    {
      changeY=-changeY;
    }
  }
}
  
  OscMessage myMessage1 = new OscMessage("/player/position");
  myMessage1.add(float(mouseX));
  myMessage1.add(float(height-base));
  
  OscMessage myMessage2 = new OscMessage("/ball/position");
  myMessage2.add(x);
  myMessage2.add(y);
  
  oscP5.send(myMessage1, myRemoteLocation); 
  oscP5.send(myMessage2, myRemoteLocation); 
}

void mouseClicked()
{
  x=width/2;
  y=height/2; 
  changeY=-changeY;
}

void oscEvent(OscMessage theOscMessage) {
  
  if(theOscMessage.addrPattern().equals("/player/position")){
  posX = theOscMessage.get(0).floatValue(); 
  posY = theOscMessage.get(1).floatValue();
  }
  if(theOscMessage.addrPattern().equals("/ball/position")){
  x = theOscMessage.get(0).floatValue();
  y = theOscMessage.get(1).floatValue();
  println(posX+","+x+","+y);
  }
}
