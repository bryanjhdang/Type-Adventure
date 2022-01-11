// Generic character class that holds a PImage and PVector for pos

class Character
{
  PImage img;
  PVector pos, vel;
  
  Character(PImage img, PVector pos){
    this.img = img;
    this.pos = pos;
  }
   
  void drawMe(){
    fill(255);
    rect(-50, -50, 100, 100);
  }
  
  void update(){
    drawMe();
  }
}
