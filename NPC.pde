// NPC subclass of character
// The player can talk to the NPC by way of collision

class NPC extends Character{
  int textIndex;
  int location;
  
  // temp
  boolean hasBeenTalkedTo;
  
  // text
  StringList convo;
  
  NPC(PImage img, PVector pos, int location, StringList convo){
    super(img, pos);
    this.location = location;
    this.convo = convo;
    
    hasBeenTalkedTo = false;
    
    textIndex = -1;
  }
  
  void drawMe(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(-1, 1);
    image(img, -img.width/2, -img.height/2);
    popMatrix();
  }
  
  // draw an exclamation over the NPC's head
  void drawCollisionExclamation(){
    pushMatrix();
    translate(pos.x, pos.y - img.height/1.8);
    fill(0);
    ellipse(0, 0, 4, 4);
    triangle(0, -7, 4, -20, -4, -20);
    popMatrix();
  }
  
  // check if the player is currently colliding with the NPC
  boolean checkCollision(){
    if(location == state && (abs(pos.x-player.pos.x)<img.width && abs(pos.y-player.pos.y)<img.height)){
      return true;
    } else {
      return false;
    }
  }
  
  // check if the player is currently interacting with something, in which case prompt a conversation text box
  void checkConversation() {
    if (player.getInteraction()) {
        // regular text
        if(textIndex < convo.size()){
          if(textIndex != -1){
            drawTextBox();
            fill(0);
            textFont(monoFont);
            textAlign(LEFT);
            textSize(40);
            String s = convo.get(textIndex);
            text(s, width/8+20, height/8+20, width-(width/8)*2-40, height/3-40);
          }
        }
        
        // end of conversation 
        if(textIndex == convo.size()){
          textIndex = -1;
          player.setTalking(false);
          hasBeenTalkedTo = true;
        }
    } else {
      textIndex = -1;
    }
  }
  
  // draw the box that the NPC text is displayed in
  void drawTextBox(){
    fill(255);
    strokeWeight(1.3);
    rectMode(CORNER);
    rect(width/8, height/8, width-int(width/8)*2, height/3);
    strokeWeight(1);
  }
  
  void update(){    
    super.update();
    checkConversation(); 
  }
  
  // move on to next thing the NPC has to say
  void increaseTextIndex(){
    if(textIndex < convo.size()) textIndex++;
  }
  
  int getLocation() { return location; }
  boolean getHasBeenTalkedTo() { return hasBeenTalkedTo; }
};
