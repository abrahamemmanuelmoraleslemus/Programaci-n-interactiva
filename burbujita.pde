import oscP5.*; 
import netP5.*;
OscP5 oscP5;

PImage photo;

ArrayList<Burbuja> burbujas = new ArrayList<Burbuja>();

int size;
NetAddress direccionRemota;
void setup () {
  size(512, 512);
  
  oscP5 = new OscP5(this, 12000);
  direccionRemota = new NetAddress("192.168.1.64", 12001);
  burbujas.add(new Burbuja(width/2, height/2));
  
  photo = loadImage("foto.jpg");
  image(photo, 0, 0);
}

void draw () {
  image(photo, 0, 0);
 
  for (Burbuja b: burbujas) {      
    b.update();
    b.display();
    b.colisiones();
  }
  
  for (int i = 0; i < burbujas.size(); i++) {
    Burbuja burb = burbujas.get(i);
    for (Burbuja b: burbujas) {
      b.colisionesBurbuja(burb);
    }
  }
}

void dividir (){
  for (Burbuja b: burbujas) {
    burbujas.remove(b);
    
    Burbuja a1, a2;
    
    a1 = new Burbuja(b.position.x+b.radio, b.position.y+b.radio); 
    a2 = new Burbuja(b.position.x-b.radio, b.position.y-b.radio);
    
    a1.radio = b.radio;
    a2.radio = b.radio;
    
    a1.diametro = a1.radio*2;
    a2.diametro = a2.radio*2;
    
    burbujas.add(a1);
    burbujas.add(a2);
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/x") == true) {
    for (Burbuja b: burbujas) {
      b.diametro = theOscMessage.get(0).floatValue();
      b.radio = b.diametro/2;
    }
  }
    
  if (theOscMessage.checkAddrPattern("/normalidad") == true) {
    for (Burbuja b: burbujas) {
      b.diametro += 5;
      b.radio = b.diametro/2;
    }
  }
  
  if (theOscMessage.checkAddrPattern("/dividir") == true) {
    dividir();
  }
  
  if (theOscMessage.checkAddrPattern("/r") == true) {
    for (Burbuja b: burbujas) {
      b.r = theOscMessage.get(0).floatValue();
    }
  }
  
  if (theOscMessage.checkAddrPattern("/g") == true) {       
    for (Burbuja b: burbujas) {
      b.g = theOscMessage.get(0).floatValue();
    }
  }
  
  if (theOscMessage.checkAddrPattern("/b") == true) {
    for (Burbuja b: burbujas) {
      b.b = theOscMessage.get(0).floatValue();
    }
  }
}
