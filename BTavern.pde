// Subclass of BEnterableBuilding that has a tavern img
// Used for collision purposes

class BTavern extends BEnterableBuilding{

  BTavern(PImage img, PVector pos, float doorWidth, float doorHeight){
    super(img, pos, doorWidth, doorHeight);
  }
  
  // limit the player's movement so he can only go left / right
  void overridePlayerMove(){
    if(state >= PLAYER_HOUSE){
      if(player.getPosY() > height/2 + height/8){
        player.setPosY(height/2 + height/8 - 75);
      }
      
      if(player.getPosY() < height/2 + height/8){
        player.setPosY(height/2 + height/8 - 75);
      }
      
      // limit the player's horizontal movement
      if(player.getPosX() > width - width/16 - width/128){
        player.setPosX(width - width/16 - width/128);
      }
    }
  }
  
  void update(){
    super.update();
    overridePlayerMove();
  }
  
}
