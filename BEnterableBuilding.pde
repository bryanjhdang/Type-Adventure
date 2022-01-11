// This class draws a building and detects if a player is standing in front of it or not
// The methods are called to check if the player is in front so the player can be transported to a new state

class BEnterableBuilding{
  PImage img;
  PVector pos;
  float doorWidth;
  float doorHeight;
  boolean detectPlayer;
  
  BEnterableBuilding(PImage img, PVector pos, float doorWidth, float doorHeight){
    this.img = img;
    this.pos = pos;
    this.doorWidth = doorWidth;
    this.doorHeight = doorHeight;
    detectPlayer = false;
  }
  
  void drawMe(){
    if(state < PLAYER_HOUSE){
      pushMatrix();
      translate(pos.x, pos.y);
      image(img, -img.width/2, -img.height);
      popMatrix();
    }
  }
  
  // check if the player is standing in front or not
  void checkCollision(){
    if(abs(pos.x-player.pos.x)<doorWidth/2 && abs((pos.y - height/24)-player.pos.y)<doorHeight/2){
      if(state <= CASTLE_3) detectPlayer = true;
    } else {
      detectPlayer = false;
    }
  }
  
  void update(){
    drawMe();
    checkCollision();
  }
  
  // getters / setters
  void setDetectPlayerFalse() { detectPlayer = false; }
  boolean getDetectPlayer() { return detectPlayer; }
}
